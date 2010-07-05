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
			realname_set($value['uid'], $value['username']);
			$sitefeed_list[] = $value; 		
};

include_once template("space_feed");

?>