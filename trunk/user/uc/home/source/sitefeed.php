<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
$sitefeed_list = array();
//$sitefeedstarttime = $_SGLOBAL['timestamp'] - $_SCONFIG['feedhotday']*3600*24;
//$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('feed')." USE INDEX(hot) WHERE dateline>='$hotstarttime' ORDER BY hot DESC LIMIT 0,10");



$cachefile = S_ROOT.'./data/cache_feed.txt';
if(check_feed_cache()) {
	$sitefeed_list = unserialize(sreadfile($cachefile));
} else {
	 $query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('feed')." ORDER BY dateline DESC LIMIT 0,5");
	 while ($value = $_SGLOBAL['db']->fetch_array($query)) {
					//realname_set($value['uid'], $value['username']);
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
