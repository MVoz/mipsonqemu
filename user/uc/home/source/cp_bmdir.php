<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//检查信息
$bmdirid = empty($_GET['bmdirid'])?0:intval($_GET['bmdirid']);
$browserid = empty($_GET['browserid'])?0:intval($_GET['browserid']);
if(empty($bmdirid))
	$bmdirid = empty($_POST['bmdirid'])?0:intval($_POST['bmdirid']);
if(empty($browserid))
	$browserid = empty($_POST['browserid'])?0:intval($_POST['browserid']);
if(empty($browserid))
	$browserid=$_SGLOBAL['browsertype']['ie'];

$ops=array('add','edit','delete');
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$bmdiritem = array();
$groupid=0;
//如果bmdirid为0，则表示为根目录
if($bmdirid)
{
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid=".$_SGLOBAL['supe_uid']." AND type=".$_SC['bookmark_type_dir']." AND groupid=".$bmdirid.' AND browserid='.$browserid);
	$bmdiritem = $_SGLOBAL['db']->fetch_array($query);
	$groupid=$bmdiritem['parentid'];
}
/*
	permit owner id item 
0--不关心
1--需要符合条件
2--几个中有一个符合即可
*/
$bmdir_priority=array(
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>0,'owner'=>1,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>0,'owner'=>1,'id'=>1,'item'=>1)
);
$ret=check_valid($op,$bmdirid,$bmdiritem,$bmdiritem['uid'],'managelink',$bmdir_priority);
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



$op = empty($_GET['op'])?'':$_GET['op'];
if(empty($op)||!in_array($op,$ops)||!checkbrowserid($browserid)){
        showmessage('error parameters');
}


if($bmdiritem)	
{
	if($_SGLOBAL['supe_uid'] != $bmdiritem['uid']/* && !checkperm('manageblog')*/) {
		showmessage('no_authority_operation_of_the_log');
	}
}


//添加编辑操作
if(submitcheck('editsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_bookmark.php');
	if($newbmdir = bookmark_post($_POST, $bmdiritem)) {
		$url = 'space.php?do=bookmark&groupid='.$newbmdir['groupid'];		
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
	if($newbmdir = bookmark_post($_POST, $bmdiritem)) {
			$url = 'space.php?do=bookmark&groupid='.$newbmdir['groupid'];
			if(empty($_SGLOBAL['client']))
				showmessage('do_success', $url, 0);
			else
				showmessage('result="do_success"'.' lastmodified="'.$_SGLOBAL['supe_timestamp'].'"'.
			' groupid="'.$newbmdir['groupid'].'"'.' bmid="'.$newbmdir['bmid'].'"');
	} else {
		showmessage('that_should_at_least_write_things');
	}

}
if($_GET['op'] == 'delete') {
	//删除
	if(submitcheck('deletesubmit')) {
		include_once(S_ROOT.'./source/function_bookmark.php');
		if($bmdirid&&deletebookmarkdir($bmdiritem['bmid'])) {
			//跳到父一级
			$url = 'space.php?do=bookmark&groupid='.$groupid.'&browserid='.$browserid;
			showmessage('do_success', $url, 0);
		}else if(empty($bmdirid)&&clearbookmark($browserid)){
			$url = 'space.php?do=bookmark&groupid=0&browserid='.$browserid;
			showmessage('do_success', $url, 0);
		}else {
			showmessage('failed_to_delete_operation');
		}
	}
	
}  elseif($_GET['op'] == 'edithot') {
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
	
} else {
	//添加编辑
//	$bmdirid=empty($_GET['bmdirid'])?0:intval($_GET['bmdirid']);
//	if(!$bmdirid){
		//error bmdir id
//			showmessage('failed_to_delete_operation');
//	}
    if($bmdirid){
	$query = $_SGLOBAL['db']->query("SELECT main.subject 
	FROM ".tname('bookmark')." main where uid=".$_GLOBAL['supe_uid']."main.type=".$_SC['bookmark_type_dir'].cond_groupid($bmdirid)."  limit 1");
	if($value =$_SGLOBAL['db']->fetch_array($query))
		$bmdirname=getstr($value['subject'], 50, 0, 0, 0, 0, -1);
	}else{
        if($_GET['op']=='edit')
            showmessage('Do_not_modify_the_dir_name');
    }
	
}

include_once template("cp_bmdir");

?>
