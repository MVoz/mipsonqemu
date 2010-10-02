<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//今日十大浏览站点
$_SGLOBAL['todayviewnum']=readsitecachefile('todayviewnum');
//历史十大浏览站点
$_SGLOBAL['viewnum']=readsitecachefile('viewnum');
//今日十大收藏站点
$_SGLOBAL['storenum']=readsitecachefile('storenum');
//历史十大收藏站点
$_SGLOBAL['todaystorenum']=readsitecachefile('todaystorenum');
?>
