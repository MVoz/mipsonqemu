<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
//今日热荐
$todayhot = array();
$todayhotlist = array();
$_SCONFIG['todayhot']='22,23,24,26';
if($_SCONFIG['todayhot']) {
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." WHERE linkid IN (".simplode(explode(',', $_SCONFIG['todayhot'])).")");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	//	realname_set($value['uid'], $value['username'], $value['name'], $value['namestatus']);
		$todayhotlist[] = $value;
	}
}
if($todayhotlist) {
	$todayhot = sarray_rand($todayhotlist, 1);
}
foreach($todayhot as $key => $value) {
	$value['link_short_subject'] = getstr(trim($value['link_subject']), 10);	
	$value['link_short_description'] = getstr(trim($value['link_description']), 90);
	$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
	$value['link_tag'] = getstr(trim($value['link_tag']), 40);
	$todayhot[$key]=$value;
}
?>
