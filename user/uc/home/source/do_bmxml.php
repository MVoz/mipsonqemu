<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: do_login.php 13210 2009-08-20 07:09:06Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

include_once(S_ROOT.'./source/function_cp.php');


//û�е�¼��
$_SGLOBAL['nologinform'] = 1;

	$password =$_GET['password'];
	$username = trim($_GET['username']);
	//$cookietime = intval($_POST['cookietime']);
	
	//$cookiecheck = $cookietime?' checked':'';
	$membername = $username;
	
	if(empty($_GET['username'])) {
		exitwithtip('users_were_not_empty_please_re_login');
	}

	//ͬ����ȡ�û�Դ
	if(!$passport = getpassport($username, $password)) {
		exitwithtip('login_failure_please_re_login');
	}
	
	$setarr = array(
		'uid' => $passport['uid'],
		'username' => addslashes($passport['username']),
		'password' => md5("$passport[uid]|$_SGLOBAL[timestamp]")//���������������
	);
	
	//include_once(S_ROOT.'./source/function_space.php');
	//��ͨ�ռ�
	//$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('space')." WHERE uid='$setarr[uid]'");
	//if(!$space = $_SGLOBAL['db']->fetch_array($query)) {
	//	$space = space_open($setarr['uid'], $setarr['username'], 0, $passport['email']);
	//}
	
	//$_SGLOBAL['member'] = $space;
	
	//ʵ��
//	realname_set($space['uid'], $space['username'], $space['name'], $space['namestatus']);
	
	//������ǰ�û�
//	$query = $_SGLOBAL['db']->query("SELECT password FROM ".tname('member')." WHERE uid='$setarr[uid]'");
	//if($value = $_SGLOBAL['db']->fetch_array($query)) {
	//	$setarr['password'] = addslashes($value['password']);
	//} else {
		//���±����û���
	//	inserttable('member', $setarr, 0, true);
	//}

	//��������session
//	insertsession($setarr);
	
	//����cookie
	ssetcookie('auth', authcode("$setarr[password]\t$setarr[uid]", 'ENCODE'), $cookietime);
	ssetcookie('loginuser', $passport['username'], 31536000);
	//ssetcookie('_refer', '');
	
	
//	$_SGLOBAL['supe_uid'] = $space['uid'];
	
	//realname_get();
	producebmxml($passport['uid'],1);
	exit();
	

?>
