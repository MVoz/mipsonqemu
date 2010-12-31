<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
$sitefeed_list = array();

$cachefile = S_ROOT.'./data/cache_feed.txt';
if(check_feed_cache()) {
	$sitefeed_list = unserialize(sreadfile($cachefile));
} else {
	//只保留前48项
	//
	 $feedcount=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('feed')), 0);
	 if( $feedcount > 48){
		$deletecount = $feedcount - 48;
		$_SGLOBAL['db']->query("DELETE FROM ".tname('feed')." ORDER BY feedid ASC LIMIT ".$deletecount);
	 }

	 $query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('feed')." ORDER BY feedid DESC LIMIT 0,20");
	 while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			$sitefeed_list[] = $value; 		
	 };
	swritefile($cachefile, serialize($sitefeed_list));
}

function check_feed_cache() {
		global $_SGLOBAL;
		$cachefile = S_ROOT.'./data/cache_feed.txt';
		$ftime = filemtime($cachefile);
		//5 minutes
		if($_SGLOBAL['timestamp'] - $ftime < 5*60) {
			return true;
		}
		return false;
}
?>
