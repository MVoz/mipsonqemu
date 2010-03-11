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
		$bookmarklist[] = $value;
	}
foreach($bookmarklist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
	$bookmarklist[$key] = $value;	
}
//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

realname_get();

?>
