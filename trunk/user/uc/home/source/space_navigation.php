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
//bookmarklist
$classid= empty($_GET['classid'])?0:intval(trim($_GET['classid']));
$childid= empty($_GET['childid'])?0:intval(trim($_GET['childid']));

 //分页获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$_SC['bookmark_show_maxnum'];
$start=$page?(($page-1)*$perpage):0;



$child_class=array();
$bookmarklist=array();
$isSecClass=0;
if($classid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.classid=".$classid);
	$classitem = $_SGLOBAL['db']->fetch_array($query);
	if(empty($classitem))
		   $classid=0;
	else
	{
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
			//先检查cache
			if(!file_exists( S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_page'.$page.'.txt'))
			{
				include_once(S_ROOT.'./source/function_cache.php');
				link_cache_classid($classid);				
			}
			$bookmarklist = unserialize(sreadfile(S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_page'.$page.'.txt'));
			$count=sreadfile(S_ROOT.'./data/linkcache/'.$classid.'/link_cache_'.$classid.'_count.txt');
		}
	}
}else{
	//显示导航
	//include_once(S_ROOT.'./source/space_bookmark_show.php');
	//获取显示的nav分类
	
	if(!file_exists( S_ROOT.'./data/navigation_cache.txt'))
	{
		include_once(S_ROOT.'./source/function_cache.php');
		navigation_cache();		
	}
	$navlist = unserialize(sreadfile(S_ROOT.'./data/navigation_cache.txt'));
}

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
realname_get();

//修正tag以便显示
foreach($bookmarklist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	include_once(S_ROOT.'./source/function_link.php');
	$value['link_tag']=convertlinktag($value['linkid'],$value['link_tag']);
	if($value[picflag]&&empty($value['tag']))
			$value['tag']= $value['link_tag'];
	$value['taglist'] = empty($value['tag'])?array():unserialize($value['tag']);
	$bookmarklist[$key] = $value;	
}

$theurl="space.php?do=$do&classid=$classid&childid=$childid";
//分页
$bookmark_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);
$_TPL['css'] = 'network';
include_once template("space_navigation");
/*
}
*/
//检查缓存
function check_network_cache($type) {
	global $_SGLOBAL;
	
	if($_SGLOBAL['network'][$type]['cache']) {
		$cachefile = S_ROOT.'./data/cache_network_'.$type.'.txt';
		$ftime = filemtime($cachefile);
		if($_SGLOBAL['timestamp'] - $ftime < $_SGLOBAL['network'][$type]['cache']) {
			return true;
		}
	}
	return false;
}



?>
