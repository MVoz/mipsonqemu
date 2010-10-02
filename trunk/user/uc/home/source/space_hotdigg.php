<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
} 

$f =  S_ROOT.'./data/data_hotdigg.txt';
if(!file_exists($f)){
	include_once(S_ROOT.'./source/function_cache.php');
	hotdigg_cache();
}
$_SGLOBAL['hotdigg'] = unserialize(sreadfile($f));
?>
