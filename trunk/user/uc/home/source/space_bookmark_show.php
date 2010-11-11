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

$wherearr='';
$orderarr='';
$theurl='';
$groupid=0;
$bookmarklist = array();
$isFromCache=0;
$at=$op;

include_once(S_ROOT.'./source/function_link.php');
include_once(S_ROOT.'./source/function_bookmark.php');
include_once(S_ROOT.'./source/function_cache.php');

//浏览器类型
$browserid=gethttpbrowserid();;
if($op=='browser'){	    
		$groupid = gethttpgroupid($browserid);
		$groupname = getbookmarkgroupname($browserid,$groupid);		
		$theurl="space.php?do=$do&op=$op&groupid=$groupid&browserid=$browserid";
}else{
		$viewstr=array(
			'lastvisit'=>array('order'=>'lastvisit','groupname'=>'最近访问'),
			'lastadd'=>array('order'=>'dateline','groupname'=>'最近添加'),
			'oftenvisit'=>array('order'=>'viewnum','groupname'=>'经常访问')
		);

		$wherearr=$wherearr." where main.uid=".$_SGLOBAL['supe_uid'];
		$wherearr=$wherearr." AND main.type=".$_SC['bookmark_type_site'];
		$orderarr=$orderarr." ORDER by main.".$viewstr[$op]['order']." DESC ";
		$groupname=	$viewstr[$op]['groupname'];
		$theurl="space.php?do=$do&op=$op";
}
	//分页获取总条数
		$perpage=$_SC['bookmark_show_maxnum'];
		$pagestart=get_page_start($perpage);

		$page = $pagestart[0];
		$start =$pagestart[1];


if(($op!='browser')){
	 //获取总数,用户首页
	$count = $perpage;
	//获取bookmarklist
	$query = $_SGLOBAL['db']->query("SELECT main.bmid FROM ".tname('bookmark')." main ".$wherearr.$orderarr." limit ".$start.",".$perpage);
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$bookmarklist[] = getbookmark($value['bmid']);
	}
}else{
	$bmcachefile=S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_'.$browserid.'_'.$groupid.'.txt';
	if(!file_exists($bmcachefile)){
		bookmark_cache_group($groupid,$browserid);
	}
	$isFromCache=1;
	$bookmarklist = unserialize(sreadfile($bmcachefile));
	$count=$bookmarklist['count'];			
	array_splice($bookmarklist, $count);//去掉最后的统计数		
	//先去掉后面
	array_splice($bookmarklist, $start+$perpage);
	//去掉前面
	$bookmarklist=array_splice($bookmarklist, $start);		
}

//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

//获得相关联的网站
$relatedlist=array();
$wherearr='';
$wherearr=$wherearr." WHERE origin=".$_SC['link_origin_link'];
$wherearr=$wherearr." AND verify=".$_SC['link_verify_passed'];
$wherearr=$wherearr." AND picflag=1";
$orderarr='';

$query = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main ".$wherearr.$orderarr." limit 0 ,".$_SC['related_site_num']);
while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			$value['link_description'] = getstr($value['link_description'], $_SC['description_related_length'], 0, 0, 0, 0, -1);
			$value['link_subject'] = getstr($value['link_subject'], $_SC['subject_related_length'], 0, 0, 0, 0, -1);
			$relatedlist[] = $value;
	}

foreach($relatedlist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$value['link_tag'] = empty($value['link_tag'])?array():unserialize($value['link_tag']);
	$relatedlist[$key] = $value;	
}
realname_get();

?>