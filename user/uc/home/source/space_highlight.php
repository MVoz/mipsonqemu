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
?>
