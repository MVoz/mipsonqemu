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

/*	
		if(($classitem['groupid']<3000)&&($classitem['groupid']>=2000))	//判断是否为第二层
		  		$isSecClass=1;
		//获取子分类
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.parentid=".$classitem['groupid']);
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
			if(!file_exists( S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_page'.$page.'.txt'))
			{
				include_once(S_ROOT.'./source/function_cache.php');
				link_cache_classid($classid);				
			}
			$bookmarklist = unserialize(sreadfile(S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_page'.$page.'.txt'));
			$count=sreadfile(S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_count.txt');
		}
*/
	}
}else{
	//显示导航
	//include_once(S_ROOT.'./source/space_bookmark_show.php');
	//获取显示的nav分类
	
	if(!file_exists($S_ROOT.'./data/navigation_cache.txt'))
	{
		include_once($S_ROOT.'./source/function_cache.php');
		navigation_cache();			
	}
	$navlist = unserialize(sreadfile(S_ROOT.'./data/navigation_cache.txt'));
}

if(!file_exists($S_ROOT.'./data/navigation_siteclass.txt'))
{
	include_once($S_ROOT.'./source/function_cache.php');
	siteclass_cache();			
}
$siteclass = unserialize(sreadfile($S_ROOT.'./data/navigation_siteclass.txt'));


//获取书签分类列表
//获取class分类
/*
$class_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=0");
while($value =$_SGLOBAL['db']->fetch_array($class_query))
{
		//获取二级目录
		$classnd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$value['groupid']);
		while($classnd_value =$_SGLOBAL['db']->fetch_array($classnd_query))
		{
			$value['son'][]=$classnd_value;
		}
	$linkclasslist[]=$value;	
}
*/
//realname_get();

//修正tag以便显示
/*
foreach($bookmarklist as $key => $value) {
	//realname_set($value['uid'], $value['username']);
	//include_once(S_ROOT.'./source/function_link.php');
	//$value['link_tag']=convertlinktag($value['linkid'],$value['link_tag']);
	//if($value[picflag]&&empty($value['tag']))
	//		$value['tag']= $value['link_tag'];
	$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
	$bookmarklist[$key] = $value;	
}
*/
//$theurl="space.php?do=$do&classid=$classid&childid=$childid";
$theurl="sitepage";
//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1,$classid.'|'.$childid.'|');
//$_TPL['css'] = 'network';
include_once template("space_navigation");
/*
}
*/

?>
