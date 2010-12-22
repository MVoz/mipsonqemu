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
if(!check_cachelock('statichtmlcache')&&($_GET['ac']=='pc'))//producecache
{
	deldir(S_ROOT.'./data/htm_cache');	
}
include_once(S_ROOT.'./source/every_highlight.php');

//bookmarklist
$classid= empty($_GET['classid'])?0:intval(trim($_GET['classid']));
$childid= empty($_GET['childid'])?0:intval(trim($_GET['childid']));

 //分页获取总条数

$perpage=$_SC['bookmark_show_maxnum'];
$pagestart=get_page_start($perpage);

$page = $pagestart[0];
$start =$pagestart[1];

$child_class=array();
$bookmarklist=array();
$isSecClass=0;
$isThirdClass=0;
$browserclassid = 0;
if($classid)
{
	//$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.classid=".$classid);
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('siteclass')." main where main.classid=".$classid);
	$classitem = $_SGLOBAL['db']->fetch_array($query);
	
	if(empty($classitem))
		   $classid=0;
	else
	{
		
	//判断是否为第二层
		$groupid = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT main.parentid FROM ".tname('siteclass')." main where main.classid=".$classitem['parentid']));
		if($groupid == 0) 
			$isSecClass=1;
		else
			$isThirdClass=1;

	//获取同一层的分类
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('siteclass')." main where main.parentid=".$classitem['classid']);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			$child_class[]=$value;
		}
		//获取下面的link信息
		if($childid)
		{
		}else{
			//修正page
			//$page=$page?($page-1):$page;
			//先检查cache
			if($isSecClass)
			{
				//获取排在最先的child
				$browserclassid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT main.classid FROM ".tname('siteclass')." main where main.parentid=".$classid.' order by displayorder LIMIT 1'));				
			}else
			{
				$browserclassid=$classid;
			}
			if(!file_exists( S_ROOT.'./data/sitecache/'.$browserclassid.'/site_cache_'.$browserclassid.'_page'.$page.'.txt'))
			{
				include_once(S_ROOT.'./source/function_cache.php');
				if($isSecClass)
					site_cache_2classid($classid);			
				else
					site_cache_3classid($browserclassid);		
			}
			$bookmarklist = unserialize(sreadfile(S_ROOT.'./data/sitecache/'.$browserclassid.'/site_cache_'.$browserclassid.'_page'.$page.'.txt'));
			$count=sreadfile(S_ROOT.'./data/sitecache/'.$browserclassid.'/site_cache_'.$browserclassid.'_count.txt');
		}
	}
}else{
	//显示导航
	//include_once(S_ROOT.'./source/space_bookmark_show.php');
	//获取显示的nav分类	
	if(!file_exists(S_ROOT.'./data/navigation_cache.txt'))
	{
		include_once(S_ROOT.'./source/function_cache.php');
		navigation_cache();			
	}
	$navlist = unserialize(sreadfile(S_ROOT.'./data/navigation_cache.txt'));
}

if(!file_exists(S_ROOT.'./data/navigation_siteclass.txt'))
{
	include_once(S_ROOT.'./source/function_cache.php');
	siteclass_cache();			
}
//获取class分类
$siteclass = unserialize(sreadfile(S_ROOT.'./data/navigation_siteclass.txt'));
$theurl="sitepage";
//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1,$classid.'|'.$childid.'|');
include_once template("space_navigation");

if(!check_cachelock('statichtmlcache')&&($_GET['ac']=='pc'))//producecache
{
	open_cachelock('statichtmlcache');
	ob_produce_static_html_cache(ob_get_contents());
	close_cachelock('statichtmlcache');
	deldir(S_ROOT.'./data/tpl_cache');	
}
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
