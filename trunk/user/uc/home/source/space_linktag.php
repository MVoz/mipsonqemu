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

$bookmarklist = array();
$tagid=empty($_GET['tagid'])?0:intval($_GET['tagid']);

//分页获取总条数
$perpage=$_SC['bookmark_show_maxnum'];
$pagestart=get_page_start($perpage);

$page = $pagestart[0];
$start =$pagestart[1];

$theurl="space.php?do=$do&tagid=$tagid";
$count = getlinktagtotalnum($tagid);
//获取tag名字
$tagname="标签:".gettagname($tagid);
//获取bookmarklist

$query = $_SGLOBAL['db']->query("SELECT main.bmid FROM ".tname('sitetagsite')." main
		 where main.uid=".$_SGLOBAL['supe_uid']." AND main.tagid=".$tagid." limit ".$start." , ".$perpage);

while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$bookmarklist[] = getbookmark($value['bmid']);
}

//分页
$multi = multi($count, $perpage, $page, $theurl,'','bmcontent');

$_TPL['css'] = 'network';
include_once template("space_linktag");
?>
