<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: do_login.php 13210 2009-08-20 07:09:06Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

	include_once(S_ROOT.'./source/function_cp.php');



	$_SGLOBAL['nologinform'] = 1;

	$passport=checkclientauth($_GET);
	exitwithtip('do_success');	

?>
