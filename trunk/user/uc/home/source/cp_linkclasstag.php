<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$ops=array('add','edit','delete');
//�����Ϣ
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$linkclasstagid= empty($_POST['linkclasstagid'])?0:intval(trim($_POST['linkclasstagid']));
$classid= empty($_POST['classid'])?0:intval(trim($_POST['classid']));
$item = array();
if($linkclasstagid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclasstag')." main where main.tagid=".$linkclasstagid);
	$item = $_SGLOBAL['db']->fetch_array($query);
}
/*
	permit owner id item 
0--������
1--��Ҫ��������
2--��������һ�����ϼ���
*/
$linkclasstag_priority=array(
 'add'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1)	
);
$ret=check_valid($op,$linkclasstagid,$item,$item['uid'],'managelinkclass',$linkclasstag_priority);
switch($ret)
{
	case -1:
		showmessage('no_authority_to_do_this');
	break;
	case -2:
		showmessage('er2ror_parameter');
	break;
	default:
	break;
}
if($op=='add'){
	if(empty($classid))
		showmessage('erroxr_parameter');
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.classid=".$classid);
	$item = $_SGLOBAL['db']->fetch_array($query);
	if(empty($item))
		showmessage('err1or_parameter');
}
 if(submitcheck('addsubmit')) {
	//��֤��
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_linkclasstag.php');
	$ret=linkclasstag_post($_POST,$item);
	if(is_array($ret)) {
		$url = $_SGLOBAL['refer'];		
		showmessage('do_success',$url,0);
	} elseif($ret==false) {
		showmessage('that_should_at_least_write_things');
	}elseif($ret==-1) {
		showmessage('link_has_existed');
	}
}
if($op == 'get'){
}
elseif($op == 'relate'){
		$relatedlist[]=$linkitem;
}
elseif($_GET['op'] == 'delete') {
	//ɾ��
	if(submitcheck('deletesubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		if(deletelink($linkid)) {
			$url =$_SGLOBAL['refer'];
			showmessage('do_success', $url, 0);
		} else {
			showmessage('failed_to_delete_operation');
		}
	}
	
}elseif($_GET['op'] == 'checkseccode'){
	//��֤��
		if(ckseccode(trim($_GET['seccode']))) {
			showmessage('succeed');
		} else {
			showmessage('incorrect_code');
		}
}
elseif($_GET['op'] == 'edithot') {
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

}elseif($_GET['op']=='manage'){

		$wherearr='';
		$orderarr='';
		$theurl='';
		$wherearr=$wherearr." where main.origin=".$_SC['link_origin_link'];
		$wherearr=$wherearr." AND main.verify=".$_SC['link_verify_undo'];

		$orderarr=$orderarr." ORDER by main.link_dateline DESC ";

		$theurl="cp.php?ac=$ac&op=$op";
		//��ҳ��ȡ������
		$page=empty($_GET['page'])?0:intval($_GET['page']);
		$perpage=$_SC['bookmark_show_maxnum'];
		$start=$page?(($page-1)*$perpage):0;
		
		//��ȡ����
		 $count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." main ".$wherearr),0);

		//��ȡ����û��ͨ����֤����ǩ�ύ
		$query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main ".$wherearr.$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);

		while($value =$_SGLOBAL['db']->fetch_array($query)){
			$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
			$linklist[]=$value;
		}
		//��ҳ
		$link_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

		$_TPL['css'] = 'network';
}elseif($_GET['op']=='pass'){
	if(submitcheck('passsubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		link_pass($linkitem);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}
} else {
	//��ӱ༭
	//�����ϰ��õ�tag�е�,ȥ��
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//��ȡ���õ�tag
	$shownums=30;
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linktag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	//��ȡclass����
	$class_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=0");
	while($value =$_SGLOBAL['db']->fetch_array($class_query))
	{
		//��ȡ����Ŀ¼
		$classnd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$value['groupid']);
		while($classnd_value =$_SGLOBAL['db']->fetch_array($classnd_query))
		{
			//��ȡ����Ŀ¼
			$classrd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$classnd_value['groupid']);
			while($classrd_value =$_SGLOBAL['db']->fetch_array($classrd_query))
			{
				$classnd_value['grandson'][]= $classrd_value;
			}
			$value['son'][]=$classnd_value;
		}
		$classlist[]=$value;
	}
}

include_once template("cp_link");

?>
