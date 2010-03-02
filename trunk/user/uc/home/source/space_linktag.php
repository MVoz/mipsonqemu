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

include_once(S_ROOT.'./data/data_network.php');

//日志
     $viewstr=array(
            'lastvisit'=>'lastvisit',
            'lastadd'=>'dateline',
            'oftenvisit'=>'visitnums',
            'lastrecommend'=>'lastvisit'
            );

	//显示数量
	  $shownum = 6;
    //$userbrowertype=getuserbrowserarray();
    //显示类别如最近访问，最新添加etc...
    $see=empty($_GET['see'])?'':$_GET['see'];
    //浏览器类型
    $browserid=(empty($_GET['browserid']))?0:intval($_GET['browserid']);
    if(!in_array($browserid,$browsertype))
        $browserid=0;	
    $tagid=empty($_GET['tagid'])?0:intval($_GET['tagid']);
    //获取总条数
    $page=empty($_GET['page'])?0:intval($_GET['page']);
    $perpage=$_SC['bookmark_show_maxnum'];
    $start=$page?(($page-1)*$perpage):0;
    $theurl="space.php?uid=$space[uid]&do=$do&tagid=$tagid";
    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('linktagbookmark')." main where main.uid=".$_SGLOBAL['supe_uid']." AND main.tagid=".$tagid),0);
    //获取tag名字
    $tagname=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT tagname FROM ".tname('linktag')." main where main.tagid=".$tagid),0);
    $tagname="Tag:".$tagname;
    //获取bookmarklist

	$query = $_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('linktagbookmark')." main
		LEFT JOIN ".tname('bookmark')." sub ON main.bmid=sub.bmid where main.uid=".$_SGLOBAL['supe_uid']." AND main.tagid=".$tagid." ORDER BY sub.dateline DESC limit ".$start." , ".$_SC['bookmark_show_maxnum']);
	$bookmarklist = array();
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['description'] = getstr($value['description'], 86, 0, 0, 0, 0, -1);
		$value['subject'] = getstr($value['subject'], 50, 0, 0, 0, 0, -1);
		//get the bookmark tag 
		$tag_query= $_SGLOBAL['db']->query("SELECT main.*,field.*  FROM ".tname('linktagbookmark')." main
			LEFT JOIN ".tname('linktag')." field ON main.tagid=field.tagid where main.bmid=".$value['bmid']);
		while($tagvalue=$_SGLOBAL['db']->fetch_array($tag_query)){
			$value['taglist'][$tagvalue['tagid']]=$tagvalue['tagname'];
		}
		$bookmarklist[] = $value;
	}
foreach($bookmarklist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$bookmarklist[$key] = $value;
}
//分页
$multi = multi($count, $perpage, $page, $theurl,'','bmcontent');

//最后登录名
$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
$wheretime = $_SGLOBAL['timestamp']-3600*24*30;

$_TPL['css'] = 'network';
include_once template("space_linktag");


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
