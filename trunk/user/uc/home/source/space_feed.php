<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: space_feed.php 13194 2009-08-18 07:44:40Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
$sitefeed_list = array();

$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('feed')." ORDER BY dateline DESC");
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

include_once template("space_feed");

?>