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

$ops = array('show');
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'show':$_GET['op'];	 

include_once(S_ROOT.'./data/data_network.php');
$wherearr='';
$orderarr='';
$theurl='';
//浏览器类型
$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$browsertype))?$browsertype['ie']:intval($_GET['browserid']);



$_TPL['css'] = 'network';
include_once template("space_browser");

?>
