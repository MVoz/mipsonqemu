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
include_once(S_ROOT.'./source/every_hotdigg.php');
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
include_once(S_ROOT.'./source/space_diggpool_show.php');

include_once template("space_diggpool");

?>
