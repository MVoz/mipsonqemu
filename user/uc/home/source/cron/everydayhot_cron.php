<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cleanfeed.php 12681 2009-07-15 05:24:47Z liguode $
*/
include_once('/var/www/uc/home/common.php');
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}


include_once(S_ROOT.'./source/function_cache.php');
everydayhot_cache();

everydayhottag_cache();

everydayhotclass_cache();

?>