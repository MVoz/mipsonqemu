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

$ops = array('mycharts');
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'mycharts':$_GET['op'];	 

include_once(S_ROOT.'./data/data_network.php');
$wherearr='';
$orderarr='';
$theurl='';
$wherearr=$wherearr." where main.postuid=".$_SGLOBAL['supe_uid'];
$wherearr=$wherearr." AND main.origin=".$_SC['link_origin_link'];

$orderarr=$orderarr." ORDER by main.link_dateline DESC ";

$groupname=	'我的上榜';

$theurl="space.php?do=$do&op=$op";

//分页获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$_SC['bookmark_show_maxnum'];
$start=$page?(($page-1)*$perpage):0;
   

//获取总数
 $count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." main ".$wherearr),0);
//获取linklist

	$query = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main ".$wherearr.$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);

	$linklist = array();

	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['link_description'] = getstr($value['description'], $_SC['description_nbox_title_length'], 0, 0, 0, 0, -1);
		$value['link_subject'] = getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
		$linklist[] = $value;
	}
foreach($linklist as $key => $value) {
	realname_set($value['postuid'], $value['username']);
	include_once(S_ROOT.'./source/function_link.php');
	$value['link_tag'] = convertlinktag($value['linkid'],$value['link_tag']);
	$value['link_tag'] = empty($value['link_tag'])?array():unserialize($value['link_tag']);
	$linklist[$key] = $value;
}
//分页
$link_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

realname_get();

//最后登录名
$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
$wheretime = $_SGLOBAL['timestamp']-3600*24*30;

$_TPL['css'] = 'network';
include_once template("space_link");

?>
