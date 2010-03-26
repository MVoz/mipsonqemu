<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_profile.php 13149 2009-08-13 03:11:26Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$_GET['op'] = 'base';

include_once S_ROOT.'./uc_client/client.php';
$uc_avatarflash = uc_avatar($_SGLOBAL['supe_uid'], (empty($_SCONFIG['avatarreal'])?'virtual':'real'));

$theurl = "cp.php?ac=config&op=$_GET[op]";
if($_GET['op'] == 'base') {
	
	if(submitcheck('configsubmit')) {
		

		
		//产生feed
		//if(ckprivacy('profile', 1)) {
		//	feed_add('profile', cplang('feed_profile_update_base'));
		//}
		$setarr = array();
		
		//邮箱问题
		$newemail = isemail($_POST['email'])?$_POST['email']:'';
		if(isset($_POST['email']) && $newemail != $space['email']) {
			
			//检查邮箱唯一性
			if($_SCONFIG['uniqueemail']) {
				if(getcount('spacefield', array('email'=>$newemail, 'emailcheck'=>1))) {
					showmessage('uniqueemail_check');
				}
			}
			
			//验证密码
			//if(!$passport = getpassport($_SGLOBAL['supe_username'], $_POST['password'])) {
			//	showmessage('password_is_not_passed');
			//}
			
			//邮箱修改
			if(empty($newemail)) {
				//邮箱删除
				$setarr['email'] = '';
				$setarr['emailcheck'] = 0;
			} elseif($newemail != $space['email']) {
				//之前已经验证
				if($space['emailcheck']) {
					//发送邮件验证，不修改邮箱
					$setarr['newemail'] = $newemail;
				} else {
					//修改邮箱
					$setarr['email'] = $newemail;
				}
				emailcheck_send($space['uid'], $newemail);
			}
		}
		
		updatetable('spacefield', $setarr, array('uid'=>$_SGLOBAL['supe_uid']));
	
		showmessage('update_on_successful_individuals', $url);
	}
	
	
} 
include template("cp_config");

?>