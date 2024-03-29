<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: do_login.php 13210 2009-08-20 07:09:06Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

include_once(S_ROOT.'./source/function_cp.php');

if($_SGLOBAL['supe_uid']) {
	showmessage('do_success', 'space.php?do=all', 0);
}

$refer = empty($_GET['refer'])?rawurldecode($_SCOOKIE['_refer']):$_GET['refer'];
/*
preg_match("/(admincp|do|cp)\.php\?ac\=([a-z]+)/i", $refer, $ms);
if($ms) {
	if($ms[1] != 'cp' || $ms[2] != 'sendmail') $refer = '';
}
*/
if(empty($refer)) {
	if(empty($_SGLOBAL['refer']))
		$refer = 'space.php?do=all';
	else
		$refer = $_SGLOBAL['refer'];
}

//好友邀请
$uid = empty($_GET['uid'])?0:intval($_GET['uid']);
$code = empty($_GET['code'])?'':$_GET['code'];
$app = empty($_GET['app'])?'':intval($_GET['app']);
$invite = empty($_GET['invite'])?'':$_GET['invite'];
$invitearr = array();
$reward = getreward('invitecode', 0);
if($uid && $code && !$reward['credit']) {
	$m_space = getspace($uid);
	if($code == space_key($m_space, $app)) {//验证通过
		$invitearr['uid'] = $uid;
		$invitearr['username'] = $m_space['username'];
	}
	$url_plus = "uid=$uid&app=$app&code=$code";
} elseif($uid && $invite) {
	include_once(S_ROOT.'./source/function_cp.php');
	$invitearr = invite_get($uid, $invite);
	$url_plus = "uid=$uid&invite=$invite";
}

//没有登录表单
$_SGLOBAL['nologinform'] = 1;

if(submitcheck('loginsubmit')) {

	$password = $_POST['password'];
	$username = trim($_POST['username']);
	$cookietime = intval($_POST['cookietime']);
	
	$cookiecheck = $cookietime?' checked':'';
	$membername = $username;
	
	if(empty($_POST['username'])) {
		showmessage('users_were_not_empty_please_re_login', 'do.php?ac='.$_SCONFIG['login_action']);
	}
	
	if($_SCONFIG['seccode_login']) {
		include_once(S_ROOT.'./source/function_cp.php');
		if(!ckseccode($_POST['seccode'])) {
			$_SGLOBAL['input_seccode'] = 1;
			include template('do_login');
			exit;
		}
	}

	//同步获取用户源
	if(!$passport = getpassport($username, $password)) {
		if($_SGLOBAL['client'])
			showmessage('login_failure_please_re_login');
		else
			showmessage('login_failure_please_re_login', 'do.php?ac='.$_SCONFIG['login_action']);
	}
	
	$setarr = array(
		'uid' => $passport['uid'],
		'username' => addslashes($passport['username']),
		'name' =>  addslashes($passport['name']),
		'password' => md5("$passport[uid]|$_SGLOBAL[timestamp]")//本地密码随机生成
	);
	
	include_once(S_ROOT.'./source/function_space.php');
	//开通空间
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('space')." WHERE uid='$setarr[uid]'");
	if(!$space = $_SGLOBAL['db']->fetch_array($query)) {
		$space = space_open($setarr['uid'], $setarr['username'], 0, $passport['email']);
	}
	
	$_SGLOBAL['member'] = $space;
	
	//实名
	realname_set($space['uid'], $space['username'], $space['name'], $space['namestatus']);
	
	//检索当前用户
	$query = $_SGLOBAL['db']->query("SELECT password FROM ".tname('member')." WHERE uid='$setarr[uid]'");
	if($value = $_SGLOBAL['db']->fetch_array($query)) {
		$setarr['password'] = addslashes($value['password']);
	} else {
		//更新本地用户库
		inserttable('member', $setarr, 0, true);
	}

	//清理在线session
	insertsession($setarr);
	
	//设置cookie
	ssetcookie('auth', authcode("$setarr[password]\t$setarr[uid]", 'ENCODE'), $cookietime);
	ssetcookie('loginuser', $passport['username'], 31536000);
	ssetcookie('_refer', '');
	
	if(!empty($cookiecheck))
			ssetcookie('cookiecheck', $cookiecheck, 31536000);
	else
			ssetcookie('cookiecheck', '');
	//同步登录
	if($_SCONFIG['uc_status']) {
		include_once S_ROOT.'./uc_client/client.php';
		$ucsynlogin = uc_user_synlogin($setarr['uid']);
	} else {
		$ucsynlogin = '';
	}
	/*
	//好友邀请
	if($invitearr) {
		//成为好友
		invite_update($invitearr['id'], $setarr['uid'], $setarr['username'], $invitearr['uid'], $invitearr['username'], $app);
	}
	$_SGLOBAL['supe_uid'] = $space['uid'];
	//判断用户是否设置了头像
	$reward = $setarr = array();
	$experience = $credit = 0;
	$avatar_exists = ckavatar($space['uid']);
	if($avatar_exists) {
		if(!$space['avatar']) {
			//奖励积分
			$reward = getreward('setavatar', 0);
			$credit = $reward['credit'];
			$experience = $reward['experience'];
			if($credit) {
				$setarr['credit'] = "credit=credit+$credit";
			}
			if($experience) {
				$setarr['experience'] = "experience=experience+$experience";
			}
			$setarr['avatar'] = 'avatar=1';
			$setarr['updatetime'] = "updatetime=$_SGLOBAL[timestamp]";
		}
	} else {
		if($space['avatar']) {
			$setarr['avatar'] = 'avatar=0';
		}
	}
	
	if($setarr) {
		$_SGLOBAL['db']->query("UPDATE ".tname('space')." SET ".implode(',', $setarr)." WHERE uid='$space[uid]'");
	}
	*/
	if(empty($_POST['refer'])) {
		//$_POST['refer'] = 'space.php?do=home';
		$_POST['refer'] = 'space.php?do=bookmark';
	}
	
	realname_get();
	/*
	if($_SGLOBAL['client']){
		header("Location: space.php?do=bookmark&browserid=1&source=client");
		return;
	}
	*/
	showmessage('login_success', $app?"userapp.php?id=$app":$_POST['refer'], 1, array($ucsynlogin));
}

$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
$cookiecheck = ' checked';
if(!empty($_SGLOBAL['client'])){
	if(empty($membername))
		$membername = sstripslashes($_GET['username']);
	if(empty($password))
		$password = sstripslashes($_GET['password']);
}
include template('do_login');

?>
