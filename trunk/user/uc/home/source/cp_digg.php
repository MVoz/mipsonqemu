<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//�����Ϣ
$op = empty($_GET['op'])?'':$_GET['op'];
$diggid=empty($_GET['diggid'])?0:$_GET['diggid'];
$diggitem = array();
$groupid=0;
if($diggid) {
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('digg')." main WHERE main.diggid=$diggid");
	$diggitem = $_SGLOBAL['db']->fetch_array($query);
}
//Ȩ�޼��
if(empty($diggitem)) {
	if(!checkperm('allowdigg')) {
		ckspacelog();
		showmessage('no_authority_to_add_digg');
	}
	
	//ʵ����֤
	ckrealname('blog');
	
	//��Ƶ��֤
	ckvideophoto('blog');
	
	//���û���ϰ
	cknewuser();
	
	//�ж��Ƿ񷢲�̫��
	$waittime = interval_check('post');
	if($waittime > 0) {
		showmessage('operating_too_fast','',1,array($waittime));
	}
	
	//�����ⲿ����
//	$diggitem['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
//	$diggitem['description'] = empty($_GET['description'])?'':getstr($_GET['description'], 500, 1, 0);
	
} else {
	$diggitem['tag'] = empty($diggitem['tag'])?array():unserialize($diggitem['tag']);
	$diggitem['tag'] = implode(' ',$diggitem['tag']);
	//if($_SGLOBAL['supe_uid'] != $bookmarkitem['uid']/* && !checkperm('manageblog')*/) {
	//	showmessage('no_authority_operation_of_the_log');
	//}
}

//��ӱ༭����
if(submitcheck('blogsubmit')) {

	if(empty($blog['blogid'])) {
		$blog = array();
	} else {
		if(!checkperm('allowblog')) {
			ckspacelog();
			showmessage('no_authority_to_add_log');
		}
	}
	
	//��֤��
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
	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_digg.php');
	if($newbmdir = digg_post($_POST, $diggitem)) {
		$url=$_SGLOBAL['refer'];	
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}else if(submitcheck('addsubmit')) {
	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_digg.php');
	if($digg = digg_post($_POST, $diggitem)) {
	//	$url = 'space.php?do=bookmark&groupid='.$newbmdir['groupid'];		
		$url=$_SGLOBAL['refer'];
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}
if($_GET['op'] == 'delete') {
	//ɾ��
	if(submitcheck('deletesubmit')) {
		include_once(S_ROOT.'./source/function_digg.php');
		if(deletedigg($diggid)) {
			$url=$_SGLOBAL['refer'];
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
	//Ȩ��
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
	//��ӱ༭
	/*
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('linktagbookmark')." main 
		LEFT JOIN ".tname('linktag')." sub ON main.tagid=sub.tagid 
		WHERE main.bmid='$bmid'");
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$bookmarkitem['tag'][]=$value['tagname'];	
	$bookmarkitem['tag']=implode(' ',$bookmarkitem['tag']);
	*/
}

include_once template("cp_digg");

?>
