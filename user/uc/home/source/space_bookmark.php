<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//是否公开
if(empty($_SCONFIG['networkpublic'])) {
	checklogin();//需要登录
}

$ops = array('lastvisit', 'lastadd', 'oftenvisit', 'album', 'lastrecommend','browser');
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'lastvisit':$_GET['op'];	 

include_once(S_ROOT.'./data/data_network.php');
$wherearr='';
$orderarr='';
$theurl='';
//浏览器类型
$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$browsertype))?$browsertype['ie']:intval($_GET['browserid']);
if($op=='browser'){	    
	$groupid=isset ($_GET['groupid'])?intval($_GET['groupid']):0;
	$groupname=(empty($groupid))?'根目录':'';
	if(empty($groupname)){
		//获取groupname
		$query = $_SGLOBAL['db']->query("SELECT main.subject FROM ".tname('bookmark')." main where uid=".$_SGLOBAL['supe_uid']." AND main.type=".$_SC['bookmark_type_dir'].cond_groupid($groupid)."  limit 1");
		if($value =$_SGLOBAL['db']->fetch_array($query))
			$groupname=getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
	}
	$wherearr=$wherearr." where main.uid=".$_SGLOBAL['supe_uid'] ;
	$wherearr=$wherearr." AND main.type=".$_SC['bookmark_type_site']  ;
	$wherearr=$wherearr." AND main.browserid=".$browserid;
	$wherearr=$wherearr." AND main.groupid=".$groupid; 

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
   

	 //获取总数
    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('bookmark')." main ".$wherearr),0);
    //获取bookmarklist

	$query = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main	LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid ".$wherearr.$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);
	$bookmarklist = array();

	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['description'] = getstr($value['description'], $_SC['description_nbox_title_length'], 0, 0, 0, 0, -1);
		$value['subject'] = getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
		//get the bookmark tag 
		$tag_query= $_SGLOBAL['db']->query("SELECT main.*,field.*  FROM ".tname('linktagbookmark')." main
			LEFT JOIN ".tname('linktag')." field ON main.tagid=field.tagid where main.bmid=".$value['bmid']);
		while($tagvalue=$_SGLOBAL['db']->fetch_array($tag_query)){
			$value['taglist'][$tagvalue['tagid']]=$tagvalue['tagname'];
		}
		$bookmarklist[] = $value;
	}
foreach($bookmarklist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$bookmarklist[$key] = $value;
}
//分页
$multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

realname_get();

//最后登录名
$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
$wheretime = $_SGLOBAL['timestamp']-3600*24*30;

$_TPL['css'] = 'network';
include_once template("space_bookmark");
//检查缓存
function check_network_cache($type) {
	global $_SGLOBAL;
	
	if($_SGLOBAL['network'][$type]['cache']) {
		$cachefile = S_ROOT.'./data/cache_network_'.$type.'.txt';
		$ftime = filemtime($cachefile);
		if($_SGLOBAL['timestamp'] - $ftime < $_SGLOBAL['network'][$type]['cache']) {
			return true;
		}
	}
	return false;
}

//获得SQL
function mk_network_sql($type, $ids, $crops, $days, $orders) {
	global $_SGLOBAL;
	
	$nt = $_SGLOBAL['network'][$type];
	
	$wherearr = array('1');
	//指定
	foreach ($ids as $value) {
		if($nt[$value]) {
			$wherearr[] = "main.{$value} IN (".$nt[$value].")";
		}
	}
	
	//范围
	foreach ($crops as $value) {
		$value1 = $value.'1';
		$value2 = $value.'2';
		if($nt[$value1]) {
			$wherearr[] = "main.{$value} >= '".$nt[$value1]."'";
		}
		if($nt[$value2]) {
			$wherearr[] = "main.{$value} <= '".$nt[$value2]."'";
		}
	}
	//时间
	foreach ($days as $value) {
		if($nt[$value]) {
			$daytime = $_SGLOBAL['timestamp'] - $nt[$value]*3600*24;
			$wherearr[] = "main.{$value}>='$daytime'";
		}
	}
	//排序
	$order = in_array($nt['order'], $orders)?$nt['order']:array_shift($orders);
	$sc = in_array($nt['sc'], array('desc','asc'))?$nt['sc']:'desc';
	
	return array('wherearr'=>$wherearr, 'order'=>$order, 'sc'=>$sc);
}

?>
