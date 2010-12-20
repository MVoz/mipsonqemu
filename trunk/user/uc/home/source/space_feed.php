<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: space_feed.php 13194 2009-08-18 07:44:40Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//根据user来查看
$uid = empty($_GET['uid'])?0:intval($_GET['uid']);
//显示数量
//$shownum = $_SC['per_page_num'];
$shownum = 5;	
//获取总条数
$page=empty($_GET['page'])?0:intval($_GET['page']);
$perpage=$shownum;
$start=$page?(($page-1)*$perpage):0;
$theurl="space.php?do=$do";

$sitefeed_list = array();
include_once(S_ROOT.'./source/function_common.php');
include_once(S_ROOT.'./source/every_highlight.php');

$wherearr='';
if(!empty($uid))
	 $wherearr=' where main.uid='.$uid;

$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('feed')." main ".$wherearr),0);

$username = getnamefromuid($uid);

$query = $_SGLOBAL['db']->query("SELECT main.*	FROM ".tname('feed')." main ".$wherearr." ORDER BY main.dateline desc LIMIT $start,$shownum");

while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	switch($value['icon'])
	{
		case 'digg':
			$q = $_SGLOBAL['db']->query("SELECT * FROM ".tname('digg')." where diggid=".$value['id']);
			if($s = $_SGLOBAL['db']->fetch_array($q))
			{
			   $s['tag'] = empty($s['tag'])?array():unserialize($s['tag']);
			   $value['relate']= $s;
			} else
				continue;
			break;
		case 'site':
			if($s=getsite($value['id']))
			{
				$value['relate']= $s;
			}else
			   continue	;
			break;
		case 'bookmark':
			if($s=getbookmark($value['id']))
			{
				$value['relate']= $s;
			}else
			   continue	;
			break;
		default:
			continue;
			break;
	}
	//realname_set($value['uid'], $value['username']);
	$sitefeed_list[] = $value; 
};
$feedmulti = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);
include_once template("space_feed");
?>