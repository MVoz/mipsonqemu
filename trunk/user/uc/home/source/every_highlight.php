<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
//今日十大浏览站点
//历史十大浏览站点
//今日十大收藏站点
//历史十大收藏站点
$hightlightlist = array('todayviewnum','viewnum','storenum','todaystorenum');
foreach($hightlightlist as $k=>$v){ 
	$_SGLOBAL[$v]=readsitecachefile($v);
}
function readsitecachefile($type)
{
	$f =  S_ROOT.'./data/site_'.$type.'.txt';
	if(!check_todayhighlist_cache($f)){
		include_once(S_ROOT.'./source/function_cache.php');
		site_today_cache($type);
	}
	$ret = unserialize(sreadfile($f));
	$r = array();
	foreach($ret as $k=>$v){
		$r[] = $v;
	}
	return $r;
}
function check_todayhighlist_cache($filename) {
		global $_SGLOBAL;
		$ftime = filemtime($filename);
		//24 hours
		if($_SGLOBAL['timestamp'] - $ftime < (24*60*60)) {
			return true;
		}
		return false;
}
?>
