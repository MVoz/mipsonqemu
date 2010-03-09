<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//检查信息
$bmid = empty($_GET['bmid'])?0:intval($_GET['bmid']);
$op = empty($_GET['op'])?'':$_GET['op'];
/*
$browserid = empty($_GET['browserid'])?0:intval($_GET['browserid']);
if(!checkbrowserid($browserid)){
        showmessage('error parameters');
}
*/
$bookmarkitem = array();
$groupid=0;
if($bmid) {
	$query=$_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('bookmark')." main LEFT JOIN ".tname('link')." sub ON main.linkid=sub.linkid 	WHERE main.bmid='$bmid' AND main.uid=".$_SGLOBAL['supe_uid']);
	$bookmarkitem = $_SGLOBAL['db']->fetch_array($query);
	$groupid=$bookmarkitem['parentid'];
}
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
	$blog['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
	$blog['message'] = empty($_GET['message'])?'':getstr($_GET['message'], 5000, 1, 0);
	
} else {
	
	if($_SGLOBAL['supe_uid'] != $bookmarkitem['uid']/* && !checkperm('manageblog')*/) {
		showmessage('no_authority_operation_of_the_log');
	}
}

//添加编辑操作
if(submitcheck('blogsubmit')) {

	if(empty($blog['blogid'])) {
		$blog = array();
	} else {
		if(!checkperm('allowblog')) {
			ckspacelog();
			showmessage('no_authority_to_add_log');
		}
	}
	
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	
	include_once(S_ROOT.'./source/function_blog.php');
	if($newblog = blog_post($_POST, $blog)) {
		if(empty($blog) && $newblog['topicid']) {
			$url = 'space.php?do=topic&topicid='.$newblog['topicid'].'&view=blog';
		} else {
			$url = 'space.php?uid='.$newblog['uid'].'&do=blog&id='.$newblog['blogid'];
		}
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}
}
else if(submitcheck('editsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_bookmark.php');
	if($newbmdir = bookmark_post($_POST, $bookmarkitem)) {
		$url = 'space.php?do=bookmark&groupid='.$bookmarkitem['groupid']."&browserid=".$browserid;		
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}else if(submitcheck('addsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_bookmark.php');
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
	
} elseif($_GET['op'] == 'goto') {
	
	$id = intval($_GET['id']);
	$uid = $id?getcount('blog', array('blogid'=>$id), 'uid'):0;

	showmessage('do_success', "space.php?uid=$uid&do=blog&id=$id", 0);
	
} elseif($_GET['op'] == 'edithot') {
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
		return;

} else {
	//添加编辑
	$bmid=empty($_GET['bmid'])?0:intval($_GET['bmid']);
	if(!$bmid){
		//error bmdir id
			showmessage('failed_to_delete_operation');
	}
	
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('linktagbookmark')." main 
		LEFT JOIN ".tname('linktag')." sub ON main.tagid=sub.tagid 
		WHERE main.bmid='$bmid'");
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$bookmarkitem['tag'][]=$value['tagname'];	
	$bookmarkitem['tag']=implode(' ',$bookmarkitem['tag']);
}

include_once template("cp_bookmark");

?>
