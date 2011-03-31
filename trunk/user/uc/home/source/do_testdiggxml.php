<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: do_login.php 13210 2009-08-20 07:09:06Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/function_cp.php');
$diggid=isset($_GET['id'])?intval($_GET['id']):0;
if($diggid > 0){
		$hasnew=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(diggid) FROM ".tname('digg')." WHERE diggid>".$diggid));
		if(!$hasnew)
			exitwithtip('0');
		else
			exitwithtip('1');
}
	exitwithtip('1');
?>
