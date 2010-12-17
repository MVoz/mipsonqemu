<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//是否公开
//if(empty($_SCONFIG['networkpublic'])) {
	checklogin();//需要登录
//}
//bookmarklist
include_once(S_ROOT.'./source/space_highlight.php');

include_once(S_ROOT.'./source/space_bookmark_show.php');
include_once(S_ROOT.'./data/data_diggcategory.php');
include_once(S_ROOT.'./source/function_digg.php');
include_once(S_ROOT.'./source/space_hotdigg.php');
//digg
$digglist = array();
//$theurl="space.php?do=digg&show=".($_SC['digg_show_maxnum']/2);
$theurl="diggpage";
//显示数量
$shownum = $_SC['digg_show_maxnum']/2;
//获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$shownum;
$cachefile =  S_ROOT.'./data/diggcache/data_diggcache'.$page.'.php';

if(!check_cachelock('digg')&&file_exists($cachefile)) {
	//没有lock,则可以读取
	include_once($cachefile);
	$count=sreadfile(S_ROOT.'./data/diggcache/digg_count.txt');
	//由于digg页面与all页面显示数量的不同，需要调整，默认为16个
	//重计算真正的页面
	$realpage = floor(($page*$shownum)/$_SC['digg_show_maxnum']);
	$digglist = $_SGLOBAL['diggcache'][$realpage ];
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

} else {

    $start=$page?(($page-1)*$perpage):0;
   	$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('digg')),0);
	$query = $_SGLOBAL['db']->query("SELECT main.*	FROM ".tname('digg')." main	ORDER BY main.dateline DESC LIMIT $start,$shownum");

	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['subject'] = getstr($value['subject'], 50);
		$value['cutsubject'] = getstr(trim($value['subject']), 28);
		$digglist[] = $value;
	}
	
}
foreach($digglist as $key => $value) {
//	realname_set($value['uid'], $value['username']);
	$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
	$value['viewnum'] = getdiggviewnum($value['diggid']);
	$digglist[$key] = $value;
}
//分页
$diggmulti = multi($count, $perpage, $page, $theurl,'diggcontent','diggcontent',1);	
//$diggmulti = multi($count, $perpage, $page, 'diggpage','diggcontent','diggcontent',1);	
/*
//投票
$cachefile = S_ROOT.'./data/cache_network_poll.txt';
if(check_network_cache('poll')) {
	$polllist = unserialize(sreadfile($cachefile));
} else {
	$sqlarr = mk_network_sql('poll',
		array('pid', 'uid'),
		array('hot','voternum','replynum'),
		array('dateline'),
		array('dateline','voternum','replynum','hot')
	);
	extract($sqlarr);

	//显示数量
	$shownum = 9;
	
	$polllist = array();
	$query = $_SGLOBAL['db']->query("SELECT main.*
		FROM ".tname('poll')." main
		WHERE ".implode(' AND ', $wherearr)."
		ORDER BY main.{$order} $sc LIMIT 0,$shownum");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		realname_set($value['uid'], $value['username']);
		$polllist[] = $value;
	}
	if($_SGLOBAL['network']['poll']['cache']) {
		swritefile($cachefile, serialize($polllist));
	}
}
foreach($polllist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$polllist[$key] = $value;
}

*/

//今日热荐
include_once(S_ROOT.'./source/todayhot.php');
include_once(S_ROOT.'./source/sitefeed.php');
/*
//竞价排名
$showlist = array();
$query = $_SGLOBAL['db']->query("SELECT sh.note, s.* FROM ".tname('show')." sh
	LEFT JOIN ".tname('space')." s ON s.uid=sh.uid
	ORDER BY sh.credit DESC LIMIT 0,23");
while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	realname_set($value['uid'], $value['username'], $value['name'], $value['namestatus']);
	$value['note'] = addslashes(getstr($value['note'], 80, 0, 0, 0, 0, -1));
	$showlist[$value['uid']] = $value;
}
if(empty($star) && $showlist) {
	$star = sarray_rand($showlist, 1);
}


//在线人数
$olcount = getcount('session', array());
*/

realname_get();

//最后登录名
//$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
//$wheretime = $_SGLOBAL['timestamp']-3600*24*30;

$_TPL['css'] = 'network';
include_once template("space_all");
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

//获得SQL
function mk_network_sql($type, $ids, $crops, $days, $orders) {
	global $_SGLOBAL;
	
	$nt = $_SGLOBAL['network'][$type];
	
	$wherearr = array('1');
	//指定
	foreach ($ids as $value) {
		if($nt[$value]) {
			$wherearr[] = "main.{$value} IN (".$nt[$value].")";
		}
	}
	
	//范围
	foreach ($crops as $value) {
		$value1 = $value.'1';
		$value2 = $value.'2';
		if($nt[$value1]) {
			$wherearr[] = "main.{$value} >= '".$nt[$value1]."'";
		}
		if($nt[$value2]) {
			$wherearr[] = "main.{$value} <= '".$nt[$value2]."'";
		}
	}
	//时间
	foreach ($days as $value) {
		if($nt[$value]) {
			$daytime = $_SGLOBAL['timestamp'] - $nt[$value]*3600*24;
			$wherearr[] = "main.{$value}>='$daytime'";
		}
	}
	//排序
	$order = in_array($nt['order'], $orders)?$nt['order']:array_shift($orders);
	$sc = in_array($nt['sc'], array('desc','asc'))?$nt['sc']:'desc';
	
	return array('wherearr'=>$wherearr, 'order'=>$order, 'sc'=>$sc);
}

?>
