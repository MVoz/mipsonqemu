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


$wherearr='';
if(!empty($uid))
	 $wherearr=' where main.uid='.$uid;

$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('feed')),0);
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
				case 'link':
						$q = $_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." where linkid=".$value['id']);
						if($s = $_SGLOBAL['db']->fetch_array($q))
						{
						   include_once(S_ROOT.'./source/function_link.php');
						   $s['link_tag'] = convertlinktag($s['linkid'],$s['link_tag']);
						   $s['link_tag'] = empty($s['link_tag'])?array():unserialize($s['link_tag']);
						   $value['relate']= $s;
						} else
						continue;
					break;
			}
			realname_set($value['uid'], $value['username']);
			$sitefeed_list[] = $value; 
};


$feedmulti = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);
include_once template("space_feed");

?>