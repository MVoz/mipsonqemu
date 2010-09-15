<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
//bookmarkΪ"��Ҫ�ղ�"
//getΪ���
$ops=array('checkerror','manage','add','edit','delete','pass','reject','checkseccode','get','relate','bookmark','reporterr','toolbar');
//�����Ϣ
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$linkid= empty($_GET['linkid'])?0:intval(trim($_GET['linkid']));
$item = array();
$relatedlist = array();
if($linkid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main where main.linkid=".$linkid);
	$item = $_SGLOBAL['db']->fetch_array($query);	
}
/*
	permit owner id item 
0--������
1--��Ҫ��������
2--��������һ�����ϼ���
*/
$link_priority=array(
 'checkerror'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'manage'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),	
 'pass'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'reject'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0), 
 'get'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'relate'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'bookmark'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'reporterr'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'toolbar'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0)
);
$ret=check_valid($op,$linkid,$item,$item['postuid'],'managelink',$link_priority);
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
if(empty($item)) {
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
//blog['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
//blog['message'] = empty($_GET['message'])?'':getstr($_GET['message'], 5000, 1, 0);
	
} 

include_once(S_ROOT.'./source/function_link.php');

if($op == 'get'){
	//��ȷ��ʾtag
	$item['link_tag'] = empty($item['link_tag'])?array():unserialize($item['link_tag']);
}
elseif($op == 'edit'){
		//����edit�ύ
		if(submitcheck('editsubmit')) {

			$item = link_post($_POST, $item);
			if(is_array($item)) {
				showmessage('do_success',$_SGLOBAL['refer']);
			} elseif($item) {
				showmessage('do_error');
			}
		}		
		//��ȷ��ʾtag
		$item['link_tag'] =implode(" ",empty($item['link_tag'])?array():unserialize($item['link_tag'])); 
}
elseif($op == 'relate'){
		//��ȷ��ʾtag
		$item['link_tag'] = empty($item['link_tag'])?array():unserialize($item['link_tag']);
		$relatedlist[]=$item;
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
	
}elseif($_GET['op']=='reporterr'){
		//�ٱ�����
		  include_once(S_ROOT.'./data/data_linkerrtype.php');
		  include_once(S_ROOT.'./source/function_link.php');
		  if(submitcheck('errsubmit')) {
			//��֤��
			if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
				showmessage('incorrect_code');
			}
			include_once(S_ROOT.'./source/function_link.php');
			$ret = linkerr_post($_POST, $item);
			if($ret) {	
				showmessage('do_success',$_SGLOBAL[refer]);
			} else{
				showmessage('that_should_at_least_write_things');
			}
		}
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


}elseif($_GET['op']=='checkerror'){

		$orderarr=$orderarr." ORDER by main.dateline DESC ";
		$theurl="cp.php?ac=$ac&op=$op";
		//��ҳ��ȡ������
		$page=empty($_GET['page'])?0:intval($_GET['page']);
		$perpage=$_SC['bookmark_show_maxnum'];
		$start=$page?(($page-1)*$perpage):0;
		
		//��ȡ����
		 $count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('linkerr')),0);

		//��ȡ����û��ͨ����֤����ǩ�ύ
		$query  = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linkerr')." main left join ".tname("link")." field on main.linkid=field.linkid ".$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);
		while($value =$_SGLOBAL['db']->fetch_array($query)){
			$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
			$err=explode(",",$value['errid']);
			$value['errid']='';
			foreach($err as $key=>$val)
			{
			   $value['errid']=$value['errid'].'   '.$key.':'.$_SGLOBAL['linkerrtype'][$val];
			}
			$value['errid']=$value['errid'].$value['other'];
			$linklist[]=$value;
			$value_err['link_description']=$value['errid'];
			$linklist[]= $value_err;
		}
		//��ҳ
		$link_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

		$_TPL['css'] = 'network'; 


}elseif($_GET['op']=='pass'){
	if(submitcheck('passsubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		link_pass($item);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}

}elseif($_GET['op']=='bookmark'){
	//��ȷ��ʾtag
	$item['link_tag'] = implode(' ',empty($item['link_tag'])?array():unserialize($item['link_tag']));

	if(submitcheck('bookmarksubmit')) {
	}
	$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:intval($_GET['browserid']);
	//��ȷ��ʾtag
	//$item['link_tag'] = implode(' ',empty($item['link_tag'])?array():unserialize($item['link_tag']));
	//��ȡ���õ�tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
}elseif($_GET['op']=='toolbar'){
	  if(submitcheck('addsubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		linktoolbar_post($_POST);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}
}else {
	 if(submitcheck('addsubmit')) {
		//��֤��
		if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
			showmessage('incorrect_code');
		}
		include_once(S_ROOT.'./source/function_link.php');
		$item = link_post($_POST, $item);
		if(is_array($item)) {
			//$url = $_SGLOBAL['refer'];		
			showmessage('do_success');
		} elseif($item==false) {
			showmessage('that_should_at_least_write_things');
		}elseif($item==-1) {
			showmessage('link_has_existed');
		}
	}
	//��ӱ༭
	//�����ϰ��õ�tag�е�,ȥ��
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//��ȡ���õ�tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	/*
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
	*/
}

include_once template("cp_link");

?>
