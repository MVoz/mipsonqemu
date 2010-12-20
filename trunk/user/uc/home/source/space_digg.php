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
include_once(S_ROOT.'./data/data_network.php');

$type = empty($_GET['type'])?0:intval($_GET['type']);
//检查type合法性
if(!isbetween($type,0,count($_SGLOBAL['diggcategory'])))
	  $type=0;
//根据postuser来查看
$uid = empty($_GET['uid'])?0:intval($_GET['uid']);
//显示数量
$shownum = empty($_GET['show'])?$_SC['digg_show_maxnum']:intval($_GET['show']);
if($shownum<=$_SC['digg_show_maxnum']/2)	
		$shownum = $_SC['digg_show_maxnum']/2;
else
		$shownum = $_SC['digg_show_maxnum'];
//获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$shownum;
$start=$page?(($page-1)*$perpage):0;
//$theurl="space.php?do=$do&show=".$shownum;
$theurl="diggpage";
//digg
$digglist = array();

//修正一下page ，0不变，其它情况减1
$nowpage=($page)?($page-1):0;

if($type)
	{
		$cachefile = S_ROOT.'./data/diggcache/data_diggcache_'.$type.'_'.$nowpage.'.php';
		$count=sreadfile(S_ROOT.'./data/diggcache/digg_'.$type.'_count.txt');
		$theurl = $theurl.'&type='.$type;
	}
else if($uid){
		$cachefile = S_ROOT.'./data/diggcache/data_diggcache_user_'.$uid.'_'.$nowpage.'.php';
		$count=sreadfile(S_ROOT.'./data/diggcache/digg_user_'.$uid.'_count.txt');
		$theurl = $theurl.'&uid='.$uid;
}
else {
	$cachefile = S_ROOT.'./data/diggcache/data_diggcache'.$nowpage.'.php';
	$count=sreadfile(S_ROOT.'./data/diggcache/digg_count.txt');
}
if(!check_cachelock('digg')&&file_exists($cachefile)) {
	//没有lock,则可以读取
	include_once($cachefile);		
	if($shownum!=$_SC['digg_show_maxnum'])
	{
		$realpage = floor((($nowpage+1)*$shownum)/$_SC['digg_show_maxnum']);
		$digglist = $_SGLOBAL['diggcache'][$realpage];
		//偶数去前8个，奇数取后8个
		if($page==0)
			$page = 1;
		$tmpdigglist = array_chunk($digglist, $shownum);
		if($page%2)//奇数
		{
			//取前8个
			$digglist = $tmpdigglist[0];
		}else{
			//移除前8个
			$digglist = $tmpdigglist[1];
		}
	}else{
		$digglist = $_SGLOBAL['diggcache'][$nowpage];
	}
} else {
   
	$wherearr='';
	if(!empty($type))
		 $wherearr=' where main.categoryid='.$type;
	if(!empty($uid))
		 $wherearr=' where main.postuid='.$uid;

    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('digg')),0);
	$query = $_SGLOBAL['db']->query("SELECT main.*	FROM ".tname('digg')." main ".$wherearr." ORDER BY main.dateline LIMIT $start,$shownum");

	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['subject'] = getstr($value['subject'], 50);
		$value['cutsubject'] = getstr(trim($value['subject']), 28);
		$digglist[] = $value;
	}
	if($_SGLOBAL['network']['digg']['cache']) {
		swritefile($cachefile, serialize($digglist));
	}
}
foreach($digglist as $key => $value) {
	//realname_set($value['uid'], $value['username']);
	$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
	$digglist[$key] = $value;
}
//分页
$diggmulti = multi($count, $perpage, $page, $theurl,'diggcontent','diggcontent',1);

include_once template("space_digg");

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
