<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//是否公开
if(empty($_SGLOBAL['supe_uid'])) {
	checklogin();//需要登录
}
include_once(S_ROOT.'./source/every_highlight.php');
include_once(S_ROOT.'./source/space_bookmark_show.php');
include_once template("space_bookmark");
?>
