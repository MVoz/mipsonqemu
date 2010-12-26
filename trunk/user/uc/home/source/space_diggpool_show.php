<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$theurl="diggpoolpage";
$digglist = array();

//修正一下page ，0不变，其它情况减1
$nowpage=($page)?($page-1):0;
$start=$page?(($page-1)*$perpage):0;
$count = 0;
if($uid){
	$theurl = $theurl.'&uid='.$uid;
}
$wherearr='';
if(!empty($uid))
	 $wherearr=' where main.postuid='.$uid;

$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('diggpool')),0);
$query = $_SGLOBAL['db']->query("SELECT main.*	FROM ".tname('diggpool')." main ".$wherearr." ORDER BY main.dateline DESC LIMIT $start,$shownum");

while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	$value['subject'] = getstr($value['subject'], 50);
	$value['cutsubject'] = getstr(trim($value['subject']), 28);
	$digglist[] = $value;
}
//分页
$diggpoolmulti = multi($count, $perpage, $page, $theurl,'diggcontent','diggcontent',1);
?>
