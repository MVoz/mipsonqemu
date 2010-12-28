<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: link.php 10953 2009-01-12 02:55:37Z liguode $
*/

include_once('./common.php');
$diggid= empty($_GET['diggid'])?0:intval(trim($_GET['diggid']));
$diggs = array();
$type='';
if(empty($_GET['url'])&&empty($diggid)) {
	showmessage('do_success', $refer, 0);
} else {
	if($diggid){
		$type = 'diggid';
		include_once(S_ROOT.'./source/function_digg.php');
		$diggs = gettwodigg($diggid);
		$url = $diggs[0]['url'];
		$title = $diggs[0]['subject'];
		$id = $diggs[0]['diggid'];
		$url2 = $diggs[1]['url'];
		$title2 = $diggs[1]['subject'];
		$id2 = $diggs[1]['diggid'];
	}else{
		$url = $_GET['url'];
		$title = $_GET['title'];
		if(!$_SCONFIG['linkguide']) {
			showmessage('do_success', $url, 0);//直接跳转
		}
	}
}
/*
$space = array();
if($_SGLOBAL['supe_uid']) {
	$space = getspace($_SGLOBAL['supe_uid']);
}
if(empty($space)) {
	//游客直接跳转
	showmessage('do_success', $url, 0);
}
*/
$url = shtmlspecialchars($url);
if(!preg_match("/^http\:\/\//i", $url)) $url = "http://".$url;

//模板调用
include_once template("iframe");

?>