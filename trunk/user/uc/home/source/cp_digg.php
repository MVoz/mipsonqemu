<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/function_digg.php');
$ops=array('add','edit','delete','up','down','view');
//检查信息
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$diggid= empty($_GET['diggid'])?0:intval(trim($_GET['diggid']));
$diggitem = array();
if($diggid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('digg')." main WHERE main.diggid=$diggid");
	$diggitem = $_SGLOBAL['db']->fetch_array($query);
}

/*
	permit owner id item 
0--不关心
1--需要符合条件
2--几个中有一个符合即可
*/
$digg_priority=array(
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'up'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'down'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'view'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1)
);
$ret=check_valid($op,$diggid,$diggitem,$diggitem['uid'],'managedigg',$digg_priority);
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

//权限检查
if(empty($diggitem)) {
	if(!checkperm('allowdigg')) {
		ckspacelog();
		showmessage('no_authority_to_add_digg');
	}	
	
	//判断是否发布太快
	$waittime = interval_check('post');
	if($waittime > 0) {
		showmessage('operating_too_fast','',1,array($waittime));
	}
	
	//接收外部标题
//	$diggitem['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
//	$diggitem['description'] = empty($_GET['description'])?'':getstr($_GET['description'], 500, 1, 0);
	
} else {
	$diggitem['tag'] = empty($diggitem['tag'])?array():unserialize($diggitem['tag']);
	$diggitem['tag'] = implode(' ',$diggitem['tag']);
	//if($_SGLOBAL['supe_uid'] != $bookmarkitem['uid']/* && !checkperm('manageblog')*/) {
	//	showmessage('no_authority_operation_of_the_log');
	//}
}

//添加编辑操作
if(submitcheck('editsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	if($newbmdir = digg_post($_POST, $diggitem)) {
		$url=$_SGLOBAL['refer'];	
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}else if(submitcheck('addsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	$digg = digg_post($_POST, $diggitem);
	if(!empty($digg)) {
		showmessage('do_success');
	} else {
		showmessage('that_should_at_least_write_things');
	}	
}
if($_GET['op'] == 'delete') {
	//删除
	if(submitcheck('deletesubmit')) {
		if(deletedigg($diggid)) {
			$url=$_SGLOBAL['refer'];
			showmessage('do_success', $url, 0);
		} else {
			showmessage('failed_to_delete_operation');
		}
	}
	
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
	
}elseif($_GET['op']=='up'){
		//更新顶数
		include_once(S_ROOT.'./source/function_digg.php');
        if(updatediggupnum($_GET['diggid']))
			showmessage($diggitem['upnum']+1);
		else{
			include_once template("message");
			return;
		}
}elseif($_GET['op']=='down'){
		//更新顶数
		include_once(S_ROOT.'./source/function_digg.php');
        if(updatediggdownnum($_GET['diggid']))
			showmessage($diggitem['downnum']+1);
		else{
			include_once template("message");
			return;
		}
}elseif($_GET['op']=='view'){
		//更新顶数
		include_once(S_ROOT.'./source/function_digg.php');
        updatediggviewnum($_GET['diggid']);
		showmessage($diggitem['viewnum']+1);
} else {
	//添加编辑
	//将$_GET 转化成$diggitem,以便cp_digg.htm显示
	if(empty($diggitem))
	{
		$diggitem['subject']=$_GET['title'];
		$diggitem['description']=$_GET['content'];
		$diggitem['url']=$_GET['url'];
		$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);
		$diggitem['tag']=$_GET['tag'];
	}
	//获取常用的digg tag
	if($op == 'add'){
		$shownums=30;
		$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('diggtag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
		while($value =$_SGLOBAL['db']->fetch_array($tag_query))
			$diggtaglist[$value['tagid']]=$value['tagname'];
	}
}

include_once template("cp_digg");

?>
