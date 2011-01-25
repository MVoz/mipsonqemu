<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_theme.php 12880 2009-07-24 07:20:24Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$op = empty($_GET['op'])?'':$_GET['op'];
$style = empty($_POST['ownerstyle'])?0:intval(trim($_POST['ownerstyle']));
if($style>2||$style<0)
	$style = 0;
if(submitcheck('stylesubmit')) {
	updatetable('space', array('style'=>$style), array('uid'=>$_SGLOBAL['supe_uid']));	
	showmessage('do_success', 'cp.php', 0);
} 
include_once template("cp_config");
?>