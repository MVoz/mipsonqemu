<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
$ops=array('edit','delete','updatevisitstat','checkseccode');
//检查信息
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'edit':$_GET['op'];

//检查信息
$bmid = empty($_GET['bmid'])?0:intval($_GET['bmid']);
$browserid = empty($_GET['browserid'])?1:intval($_GET['browserid']);

$bookmarkitem = array();
$groupid=0;
if($bmid) {
	$query=$_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('bookmark')." main LEFT JOIN ".tname('link')." sub ON main.linkid=sub.linkid 	WHERE main.bmid='$bmid' AND main.uid=".$_SGLOBAL['supe_uid']);
	$bookmarkitem = $_SGLOBAL['db']->fetch_array($query);
	if(empty($bookmarkitem['tag']))
		$bookmarkitem['tag'] =implode(' ',empty($bookmarkitem['link_tag'])?array():unserialize($bookmarkitem['link_tag']));
	else
		$bookmarkitem['tag'] =implode(' ',empty($bookmarkitem['tag'])?array():unserialize($bookmarkitem['tag']));

	if(empty($bookmarkitem['description']))
		$bookmarkitem['description'] =$bookmarkitem['link_description'];
	
	$groupid=$bookmarkitem['parentid'];
}

/*
	permit owner id item 
0--不关心
1--需要符合条件
2--几个中有一个符合即可
*/
$bookmark_priority=array(
 'edit'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'updatevisitstat'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0)
);

$ret=check_valid($op,$bmid,$bookmarkitem,$bookmarkitem['uid'],'allowbookmark',$bookmark_priority);
switch($ret)
{
	case -1:
		showmessage('no_authority_to_do_this');
	break;
	case -2:
		showmessage('error_parameter');
	break;
	default:
	break;
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
		//showmessage('do_success');
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
			if(empty($_SGLOBAL['client']))
				showmessage('do_success'.' lastmodified='.$_SGLOBAL['supe_starttime'], $url, 0);
			else
				showmessage('result="do_success"'.' lastmodified="'.$_SGLOBAL['supe_timestamp'].'"');
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

}

include_once template("cp_bookmark");

?>
