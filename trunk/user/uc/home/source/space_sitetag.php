<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/every_highlight.php');
//是否公开
if(empty($_SCONFIG['networkpublic'])) {
	checklogin();//需要登录
}

$tagid=empty($_GET['tagid'])?0:intval($_GET['tagid']);
    //获取总条数

$perpage=$_SC['bookmark_show_maxnum'];
$pagestart=get_page_start($perpage);

$page = $pagestart[0];
$start =$pagestart[1];

$theurl="space.php?do=$do&tagid=$tagid";

//获取tag名字
$tagname="标签:".gettagname($tagid);
//获取bookmarklist
$fileprefix = S_ROOT.'./data/sitetagcache/'.$tagid.'/sitetag_cache';
if(!file_exists($fileprefix.'_'.$tagid.'_page'.$page.'.txt')){
	include_once(S_ROOT.'./source/function_cache.php');
	sitetag_cache($tagid);
}

$bookmarklist = unserialize(sreadfile($fileprefix.'_'.$tagid.'_page'.$page.'.txt'));
$count=sreadfile($fileprefix.'_'.$tagid.'_count.txt');
//分页
$multi = multi($count, $perpage, $page, $theurl,'','bmcontent');

$_TPL['css'] = 'network';

include_once template("space_sitetag");

?>
