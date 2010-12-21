<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

if(empty($_SGLOBAL['supe_uid'])) {
	checklogin();//需要登录
}

include_once(S_ROOT.'./source/every_highlight.php');
include_once(S_ROOT.'./source/every_hotdigg.php');

include_once(S_ROOT.'./source/function_digg.php');
include_once(S_ROOT.'./source/space_bookmark_show.php');

$uid = 0;//digg
$perpage=$shownum = $_SC['digg_show_maxnum']/2;
$page=empty($_GET['page'])?0:intval($_GET['page']);

include_once(S_ROOT.'./source/space_digg_show.php');


include_once template("space_all");

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
