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

include_once(S_ROOT.'./source/every_highlight.php');

//根据postuser来查看
$uid = empty($_GET['uid'])?0:intval($_GET['uid']);
//显示数量
$shownum = empty($_GET['show'])?$_SC['digg_show_maxnum']:intval($_GET['show']);
if($shownum<=$_SC['digg_show_maxnum']/2)	
		$shownum = $_SC['digg_show_maxnum']/2;
else
		$shownum = $_SC['digg_show_maxnum'];
//获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$shownum;
include_once(S_ROOT.'./source/space_digg_show.php');

include_once template("space_digg");

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
?>
