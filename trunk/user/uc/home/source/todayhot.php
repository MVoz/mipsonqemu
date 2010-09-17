<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
//今日热荐
	$todayhot=array();
	if(!file_exists(S_ROOT.'./data/todayhot.txt')){
		include_once(S_ROOT.'./source/function_cache.php');
		everydayhot_cache();
	}
	$todayhot = unserialize(sreadfile(S_ROOT.'./data/todayhot.txt'));
?>
