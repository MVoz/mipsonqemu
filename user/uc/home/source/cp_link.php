<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//检查信息
$op = empty($_GET['op'])?'':$_GET['op'];

$bookmarkitem = array();
//权限检查
if(empty($bookmarkitem)) {
	if(!checkperm('allowblog')) {
		ckspacelog();
		showmessage('no_authority_to_add_log');
	}
	
	//实名认证
	ckrealname('blog');
	
	//视频认证
	ckvideophoto('blog');
	
	//新用户见习
	cknewuser();
	
	//判断是否发布太快
	$waittime = interval_check('post');
	if($waittime > 0) {
		showmessage('operating_too_fast','',1,array($waittime));
	}
	
	//接收外部标题
//blog['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
//blog['message'] = empty($_GET['message'])?'':getstr($_GET['message'], 5000, 1, 0);
	
} else {
	
	if($_SGLOBAL['supe_uid'] != $bookmarkitem['uid']/* && !checkperm('manageblog')*/) {
		showmessage('no_authority_operation_of_the_log');
	}
}

 if(submitcheck('addsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_link.php');
	if($newbmdir = bookmark_post($_POST, $bmdir)) {
		$url = 'space.php?do=bookmark&groupid='.$newbmdir['groupid'];		
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}
if($_GET['op'] == 'delete') {
	//删除
	if(submitcheck('deletesubmit')) {
		include_once(S_ROOT.'./source/function_bookmark.php');
		if(deletebookmark($bmid)) {
			$url = 'space.php?do=bookmark&groupid='.$groupid."&browserid=".$browserid;
			showmessage('do_success', $url, 0);
		} else {
			showmessage('failed_to_delete_operation');
		}
	}
	
}elseif($_GET['op'] == 'checkseccode'){
	//验证码
		if(ckseccode(trim($_GET['seccode']))) {
			showmessage('succeed');
		} else {
			showmessage('incorrect_code');
		}
}
elseif($_GET['op'] == 'edithot') {
	//权限
	if(!checkperm('manageblog')) {
		showmessage('no_privilege');
	}
	
	if(submitcheck('hotsubmit')) {
		$_POST['hot'] = intval($_POST['hot']);
		updatetable('blog', array('hot'=>$_POST['hot']), array('blogid'=>$blog['blogid']));
		if($_POST['hot']>0) {
			include_once(S_ROOT.'./source/function_feed.php');
			feed_publish($blog['blogid'], 'blogid');
		} else {
			updatetable('feed', array('hot'=>$_POST['hot']), array('id'=>$blog['blogid'], 'idtype'=>'blogid'));
		}
		
		showmessage('do_success', "space.php?uid=$blog[uid]&do=blog&id=$blog[blogid]", 0);
	}
	
}elseif($_GET['op']=='updatevisitstat'){
		include_once(S_ROOT.'./source/function_bookmark.php');
        updatevisitstat($_GET['bmid']);

} else {
	//添加编辑
}

include_once template("cp_link");

?>
