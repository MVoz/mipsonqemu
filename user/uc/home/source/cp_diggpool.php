<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/function_diggpool.php');
$ops=array('add','delete','publish');
//�����Ϣ
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$diggpoolid= empty($_GET['diggpoolid'])?0:intval(trim($_GET['diggpoolid']));
$diggpoolitem = array();
if($diggpoolid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('diggpool')." main WHERE main.diggpoolid=$diggpoolid");
	$diggpoolitem = $_SGLOBAL['db']->fetch_array($query);
}

/*
	permit owner id item 
0--������
1--��Ҫ��������
2--��������һ�����ϼ���
*/
$digg_priority=array(
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'publish'=>array('permit'=>2,'owner'=>2,'id'=>0,'item'=>0),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
);
$ret=check_valid($op,$diggpoolid,$diggpoolitem,$diggpoolitem['uid'],'managedigg',$digg_priority);
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

//Ȩ�޼��
if(empty($diggpoolitem)) {
	if(!checkperm('allowdigg')) {
		showmessage('no_authority_to_add_digg');
	}	
	
	//�ж��Ƿ񷢲�̫��
	$waittime = interval_check('post');
	if($waittime > 0) {
		showmessage('operating_too_fast','',1,array($waittime));
	}
} else {
	$diggpoolitem['tag'] = empty($diggpoolitem['tag'])?array():unserialize($diggpoolitem['tag']);
	$diggpoolitem['tag'] = implode(' ',$diggpoolitem['tag']);
}

if(submitcheck('addsubmit')) {
	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	$digg = diggpool_post($_POST);
	if(!empty($digg)) {
		showmessage('do_success');
	} else {
		showmessage('that_should_at_least_write_things');
	}	
}
if($op == 'delete') {
	//ɾ��
	if(submitcheck('deletesubmit')) {
		if($type=='pool')
			$ret = deletediggpool($diggpoolid);
		else
			$ret = deletedigg($diggpoolid);
		if($ret) {
			$url=$_SGLOBAL['refer'];
			showmessage('do_success', $url, 0);
		} else {
			showmessage('failed_to_delete_operation');
		}
	}
	
}else if($op == 'publish') {
	if(empty($diggpoolitem))
	{
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('diggpool')." main ORDER BY main.diggpoolid DESC LIMIT 0,1");
		$diggpoolitem = $_SGLOBAL['db']->fetch_array($query);
	} 	
	if(publishdiggpool($diggpoolitem))
	 	showmessage('do_success'); 
	else
		showmessage('diggpool_empty'); 
}else {
	//��ӱ༭
	//��$_GET ת����$diggitem,�Ա�cp_digg.htm��ʾ
	if(empty($diggpoolitem))
	{
		$diggpoolitem['subject']=$_GET['title'];
		$diggpoolitem['description']=$_GET['content'];
		$diggpoolitem['url']=$_GET['url'];
		$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);
		$diggpoolitem['tag']=$_GET['tag'];
	}
	//��ȡ���õ�digg tag
	$shownums=30;
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('diggtag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$diggtaglist[$value['tagid']]=$value['tagname'];
}  
include_once template("cp_digg");
?>
