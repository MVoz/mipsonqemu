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

$tagid=empty($_GET['tagid'])?0:intval($_GET['tagid']);
    //获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$start=$page?(($page-1)*$perpage):0;
$theurl="space.php?do=$do&tagid=$tagid";
$count = getsitetagtotalnum($tagid);
//获取tag名字
$tagname="标签:".gettagname($tagid);
//获取bookmarklist

$query = $_SGLOBAL['db']->query("SELECT main.siteid FROM ".tname('sitetagsite')." main where main.tagid=".$tagid." AND main.siteid>0
		limit ".$start." , ".$_SC['bookmark_show_maxnum']);
$bookmarklist = array();
while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	$bookmarklist[] = getsite($value['siteid']);
}
//分页
$multi = multi($count, $perpage, $page, $theurl,'','bmcontent');

$_TPL['css'] = 'network';

include_once template("space_linktag");

?>
