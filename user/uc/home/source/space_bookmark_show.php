<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$ops = array('lastvisit', 'lastadd', 'oftenvisit', 'album', 'lastrecommend','browser');
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'lastvisit':$_GET['op'];	 

//include_once(S_ROOT.'./data/data_network.php');
include_once(S_ROOT.'./source/function_link.php');
include_once(S_ROOT.'./source/function_bookmark.php');
$isFromCache=0;
include_once(S_ROOT.'./source/function_cache.php');
bookmark_cache();
bookmark_groupname_cache();
usermenu_cache();

$bookmarklist = array();
/*
$bmcachefile = S_ROOT.'./data/cache_bookmark_uid_'.$_SGLOBAL['supe_uid'].'.txt';
if(file_exists($bmcachefile)){
	$bookmarklist = unserialize(sreadfile($bmcachefile));
}else{
*/
	$wherearr='';
	$orderarr='';
	$theurl='';
	$groupid=0;
	//浏览器类型
	$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:intval($_GET['browserid']);
	if($op=='browser'){	    
		$groupid=isset ($_GET['groupid'])?intval($_GET['groupid']):0;
		//firefox做特殊处理，点击根目录直接转到书签菜单
		if(($browserid==$_SGLOBAL['browsertype']['firefox']))
		{
			$_SGLOBAL['firefox_menu_groupid']=getFirefoxBookmarkMenuGroupid();
			$_SGLOBAL['firefox_tool_groupid']=getFirefoxBookmarkToolGroupid();
			if(empty($groupid))
				$groupid=$_SGLOBAL['firefox_menu_groupid'];
		}

		$groupname=(empty($groupid))?'根目录':'';
		if(empty($groupname)){
			//获取groupname
			//先检查cache
			if(file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_groupname.php'))
			{
					include_once(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_groupname.php');
					$groupname=$_SGLOBAL['bookmark_groupname'][$browserid][$groupid];
			}else{
				$query = $_SGLOBAL['db']->query("SELECT main.subject FROM ".tname('bookmark')." main where uid=".$_SGLOBAL['supe_uid']." AND main.type=".$_SC['bookmark_type_dir'].cond_groupid($groupid)." AND main.browserid=".$browserid."  limit 1");
				if($value =$_SGLOBAL['db']->fetch_array($query))
					$groupname=getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
			}
			if(empty($groupname))
				showmessage('error_parameter');
			
		}
		$wherearr=$wherearr." where main.uid=".$_SGLOBAL['supe_uid'] ;
		$wherearr=$wherearr." AND main.type=".$_SC['bookmark_type_site']  ;
		$wherearr=$wherearr." AND main.browserid=".$browserid;
		$wherearr=$wherearr." AND main.parentid=".$groupid; 

		$orderarr=$orderarr." ORDER by main.lastvisit DESC ";

		$theurl="space.php?do=$do&op=$op&groupid=$groupid&browserid=$browserid";
	}
	else{
				$viewstr=array(
					'lastvisit'=>array('order'=>'lastvisit','groupname'=>'最近访问'),
					'lastadd'=>array('order'=>'dateline','groupname'=>'最近添加'),
					'oftenvisit'=>array('order'=>'visitnums','groupname'=>'经常访问')
				);

			$wherearr=$wherearr." where main.uid=".$_SGLOBAL['supe_uid'];
			$wherearr=$wherearr." AND main.type=".$_SC['bookmark_type_site'];

			$orderarr=$orderarr." ORDER by main.".$viewstr[$op]['order']." DESC ";

			$groupname=	$viewstr[$op]['groupname'];

			$theurl="space.php?do=$do&op=$op";
	}
	//分页获取总条数
		$page=empty($_GET['page'])?0:intval($_GET['page']);
		$perpage=$_SC['bookmark_show_maxnum'];
		$start=$page?(($page-1)*$perpage):0;
		$bmcachefile=S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_'.$browserid.'_'.$groupid.'.txt';
		if(($op!='browser')||(!file_exists($bmcachefile))){
			 //获取总数,用户首页
			$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('bookmark')." main ".$wherearr),0);
			//获取bookmarklist

			$query = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main	LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid ".$wherearr.$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);

			while ($value = $_SGLOBAL['db']->fetch_array($query)) {
				//处理link在site中的情况
				include_once(S_ROOT.'./source/function_common.php');
				$value = getlinkfromsite($value);
				$value['description'] = getstr($value['description'], $_SC['description_nbox_title_length'], 0, 0, 0, 0, -1);
				$value['subject'] = getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
				if($value[picflag]&&empty($value['description']))
					$value['description']= getstr($value['link_description'], $_SC['description_nbox_title_length'], 0, 0, 0, 0, -1);
				if($value[picflag]&&empty($value['subject']))
					$value['subject']= getstr($value['link_subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
				$bookmarklist[] = $value;
			}
		}else{
			$isFromCache=1;
			$bookmarklist = unserialize(sreadfile($bmcachefile));
			$count=$bookmarklist['count'];
			
			array_splice($bookmarklist, $count);//去掉最后的统计数
		
			//先去掉后面
			array_splice($bookmarklist, $start+$perpage);
			//去掉前面
			$bookmarklist=array_splice($bookmarklist, $start);
			
		
		}
	foreach($bookmarklist as $key => $value) {
		realname_set($value['uid'], $value['username']);
		include_once(S_ROOT.'./source/function_link.php');
		$value['link_tag']=convertlinktag($value['linkid'],$value['link_tag']);
		if($value[picflag]&&empty($value['tag']))
		{
			//将link的tag赋予bookmark
			
			$tagarray = empty($value['link_tag'])?array():unserialize($value['link_tag']);
			bookmark_tag_batch($value['bmid'],implode(" ", $tagarray));
			$value['tag']= $value['link_tag'];
			updatetable('bookmark', array('tag'=>$value['tag']), array('bmid'=>$value['bmid']));
		}
		$value['taglist'] = empty($value['tag'])?array():unserialize($value['tag']);
		$bookmarklist[$key] = $value;	
	}
/*
	swritefile($bmcachefile, serialize($bookmarklist));
}
*/
//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

//获得相关联的网站
$relatedlist=array();
$wherearr='';
$wherearr=$wherearr." WHERE origin=".$_SC['link_origin_link'];
$wherearr=$wherearr." AND verify=".$_SC['link_verify_passed'];
$wherearr=$wherearr." AND picflag=1";
//$wherearr=$wherearr."";
$orderarr='';

$query = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main ".$wherearr.$orderarr." limit 0 ,".$_SC['related_site_num']);
while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['link_description'] = getstr($value['link_description'], $_SC['description_related_length'], 0, 0, 0, 0, -1);
		$value['link_subject'] = getstr($value['link_subject'], $_SC['subject_related_length'], 0, 0, 0, 0, -1);
		$relatedlist[] = $value;
	}
foreach($relatedlist as $key => $value) {
	realname_set($value['uid'], $value['username']);
//	$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
	$value['link_tag'] = empty($value['link_tag'])?array():unserialize($value['link_tag']);
	$relatedlist[$key] = $value;	
}

realname_get();

?>
