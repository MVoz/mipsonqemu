<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp.php 13003 2009-08-05 06:46:06Z liguode $
*/

//通用文件
include_once('./common.php');
include_once(S_ROOT.'./source/function_cp.php');
//include_once(S_ROOT.'./source/function_magic.php');

//允许的方法
$acs = array('bookmark','bmdir','bm','space','digg','diggpool','site','link', 'common', 'class','config','style','upload', 'avatar',  'invite','sendmail', 'password','share','htmlcache'  
	);
/*
	cancel action
	'userapp', 'task', 'credit','domain', 'event', 'poll','click','magic', 'top', 'videophoto','topic','profile', 'theme', 'import', 'feed', 'privacy', 'pm', 'advance','swfupload', 'thread', 'mtag', 'poke', 'friend', 'doing', 'upload', 'comment', 'blog', 'album',
	'relatekw', 
*/
$ac = (empty($_GET['ac']) || !in_array($_GET['ac'], $acs))?'config':$_GET['ac'];
$op = empty($_GET['op'])?'':$_GET['op'];

if(
	($ac=='site'&&$op=='get')
  )
{
}else{
//权限判断
	if(empty($_SGLOBAL['supe_uid'])) {

			if($_SERVER['REQUEST_METHOD'] == 'GET') {
				ssetcookie('_refer', rawurlencode($_SERVER['REQUEST_URI']));
			} else {
				ssetcookie('_refer', rawurlencode('cp.php?ac='.$ac));
			}
			showmessage('to_login', 'do.php?ac='.$_SCONFIG['login_action']);
		
	}

	//获取空间信息
	$space = getspace($_SGLOBAL['supe_uid']);
	if(empty($space)) {
		showmessage('space_does_not_exist');
	}
}
/*
//是否关闭站点
if(!in_array($ac, array('common', 'pm'))) {
	checkclose();
	//空间被锁定
	if($space['flag'] == -1) {
		showmessage('space_has_been_locked');
	}
	//禁止访问
	if(checkperm('banvisit')) {
		ckspacelog();
		showmessage('you_do_not_have_permission_to_visit');
	}
	//验证是否有权限玩应用
	if($ac =='userapp' && !checkperm('allowmyop')) {
		showmessage('no_privilege');
	}
}
*/
//菜单
$actives = array($ac => ' class="active"');
runlog('action', 'cp_'.$ac);
include_once(S_ROOT.'./source/cp_'.$ac.'.php');

?>
