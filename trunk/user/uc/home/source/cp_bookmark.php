<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
$ops=array('get','edit','delete','updatebookmarkview','checkseccode');
//�����Ϣ
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'get':$_GET['op'];

//�����Ϣ
$bmid = empty($_GET['bmid'])?0:intval($_GET['bmid']);
$browserid = empty($_GET['browserid'])?1:intval($_GET['browserid']);
include_once(S_ROOT.'./source/function_bookmark.php');
$item = array();
$groupid=0;
if($bmid) {
	/*
	$query=$_SGLOBAL['db']->query("SELECT main.*, sub.* FROM ".tname('bookmark')." main LEFT JOIN ".tname('link')." sub ON main.linkid=sub.linkid 	WHERE main.bmid='$bmid' AND main.uid=".$_SGLOBAL['supe_uid']);
	$item = $_SGLOBAL['db']->fetch_array($query);
	//����link��site�е����
	$item = getlinkfromsite($item);
	if(empty($item['tag']))
		$item['tag'] =implode(' ',empty($item['link_tag'])?array():unserialize($item['link_tag']));
	else
		$item['tag'] =implode(' ',empty($item['tag'])?array():unserialize($item['tag']));
	$item['link_tag'] = explode(' ',$item['tag']);
	if(empty($item['description']))
		$item['description'] =$item['link_description'];
	*/
	$item = getbookmark($bmid);
	$groupid=$item['parentid'];
}

/*
	permit owner id item 
0--������
1--��Ҫ��������
2--��������һ�����ϼ���
*/
$bookmark_priority=array(
 'get'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'edit'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'updatebookmarkview'=>array('permit'=>1,'owner'=>1,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'updatebookmarkupnum'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'updatebookmarkdownnum'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
);

$ret=check_valid($op,$bmid,$item,$item['uid'],'allowbookmark',$bookmark_priority);
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

if(submitcheck('editsubmit')) {

	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}

	if($newbmdir = bookmark_post($_POST, $item)) {
		$url = 'space.php?do=bookmark&op=browser&groupid='.$item['groupid']."&browserid=".$browserid;		
		showmessage('do_success', $url, 0);
		//showmessage('do_success');
	} else {
		showmessage('that_should_at_least_write_things');
	}

}else if(submitcheck('addsubmit')) {
	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	if($newbmdir = bookmark_post($_POST, $bmdir)) {
		$url = 'space.php?do=bookmark&op=browser&groupid='.$newbmdir['groupid'];		
		showmessage('do_success', $url, 0);
	} else {
		showmessage('that_should_at_least_write_things');
	}

}
if($_GET['op'] == 'delete') {
	//ɾ��
	if(submitcheck('deletesubmit')) {
		if(deletebookmark($bmid)) {
			//$url = 'space.php?do=bookmark&op=browser&groupid='.$groupid."&browserid=".$browserid;
			if(empty($_SGLOBAL['client']))
				showmessage('do_success'.' lastmodified='.$_SGLOBAL['supe_starttime'], $_SGLOBAL['refer'], 0);
			else
				showmessage('result="do_success"'.' lastmodified="'.$_SGLOBAL['supe_timestamp'].'"');
		} else {
			showmessage('failed_to_delete_operation');
		}
	}
	
} elseif($_GET['op']=='updatebookmarkview'){
		updatestatistic('bookmark','viewnum',array('updateid'=>$item['bmid'],'feedid'=>$item['linkid'],'siteid'=>$item['siteid']));
		//showmessage($item['viewnum']+1);
		return;

}elseif($_GET['op']=='updatebookmarkupnum'){
		//���¶���
		if(updatestatistic('bookmark','up',array('updateid'=>$item['linkid'],'feedid'=>$item['bmid'])))
			showmessage($item['up']+1);
		else{
			$errstr=$item['up'];
			include_once template("message");
			return;

		}

}elseif($_GET['op']=='updatebookmarkdownnum'){
		//���¶���
        if(updatestatistic('bookmark','down',array('updateid'=>$item['linkid'],'feedid'=>$item['bmid'])))
			showmessage($item['down']+1);
		else{
			$errstr=$item['down'];
			include_once template("message");
			return;

		}

} else {
	//��ӱ༭

}

include_once template("cp_bookmark");

?>
