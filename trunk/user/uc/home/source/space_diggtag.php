<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/every_highlight.php');
//是否公开
if(empty($_SCONFIG['networkpublic'])) {
	checklogin();//需要登录
}

    $tagid=empty($_GET['tagid'])?0:intval($_GET['tagid']);
    //获取总条数
    $page=empty($_GET['page'])?0:intval($_GET['page']);
    $perpage=$_SC['digg_show_maxnum'];
    $start=$page?(($page-1)*$perpage):0;
    $theurl="space.php?uid=$space[uid]&do=$do&tagid=$tagid";
    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('diggtagdigg')." main where main.tagid=".$tagid),0);
    //获取tag名字
    $tagname=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT tagname FROM ".tname('diggtag')." main where main.tagid=".$tagid),0);
    $tagname="标签:".$tagname;
    //获取digglist

	$query = $_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('diggtagdigg')." main
		LEFT JOIN ".tname('digg')." sub ON main.diggid=sub.diggid where main.tagid=".$tagid." ORDER BY sub.dateline DESC limit ".$start." , ".$_SC['digg_show_maxnum']);
	$bookmarklist = array();
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
		$digglist[] = $value;
	}

//分页
$multi = multi($count, $perpage, $page, $theurl,'','bmcontent');

$_TPL['css'] = 'network';
include_once template("space_digg");


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
