<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

if(!check_cachelock('statichtmlcache'))//producecache
{
	deldir(S_ROOT.'./data/htm_cache');	
}
include_once(S_ROOT.'./source/every_highlight.php');



//显示导航
//获取显示的nav分类	
if(!file_exists(S_ROOT.'./data/navigation_cache.txt'))
{
	include_once(S_ROOT.'./source/function_cache.php');
	navigation_cache();			
}
$navlist = unserialize(sreadfile(S_ROOT.'./data/navigation_cache.txt'));
if(!file_exists(S_ROOT.'./data/navigation_siteclass.txt'))
{
	include_once(S_ROOT.'./source/function_cache.php');
	siteclass_cache();			
}
//获取class分类
$siteclass = unserialize(sreadfile(S_ROOT.'./data/navigation_siteclass.txt'));
//今日热荐
include_once(S_ROOT.'./source/every_todayhot.php');
//digg关注
include_once(S_ROOT.'./source/every_hotdigg.php');
//获取快速导航
if(!file_exists(S_ROOT.'./data/navigation_cache.txt'))
{
	include_once(S_ROOT.'./source/function_cache.php');
	navigation_cache();			
}
$navlist = unserialize(sreadfile(S_ROOT.'./data/navigation_cache.txt'));
//网友热藏
include_once(S_ROOT.'./source/every_todayhotcollect.php');
//支取hotcollect前4个
$hotsite = array_slice($todayhotcollect['site'], 0, 4);




include_once template("cp_htmlcache");
if(!check_cachelock('statichtmlcache'))//producecache
{
	open_cachelock('statichtmlcache');
	ob_produce_static_html_cache(ob_get_contents());
	close_cachelock('statichtmlcache');
	deldir(S_ROOT.'./data/tpl_cache');	
}
showmessage('do_success',$_SGLOBAL['refer']);
function ob_produce_static_html_cache($s)
{
	$s = preg_replace("/\<\!\-\-\<static\s+([a-z0-9_\/]+)\>\-\-\>(.+?)\<\!\-\-\<\/static\>\-\-\>/ies", "writestatic('\\1','\\2')", $s);
}
function writestatic($name,$original) {
	global $_SGLOBAL, $_SCONFIG; 	
	$tplfile = S_ROOT.'./data/htm_cache/'.$name.'.htm';
	if(file_exists($tplfile))
		unlink($tplfile);
	$original=str_replace("\\\"", "\"", $original);	
	if(!swritefile($tplfile, $original)) {
		return;
	}
	return;	
}
?>
