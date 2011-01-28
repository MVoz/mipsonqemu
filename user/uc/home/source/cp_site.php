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
$ops=array('checkerror','add','edit','delete','checkseccode','get','relate','bookmark','up','down','view','reporterr','store');
//�����Ϣ
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$siteid= empty($_GET['siteid'])?0:intval(trim($_GET['siteid']));
$item = array();
$relatedlist = array();
if($siteid)
		$item = getsite($siteid);
/*
	permit owner id item 
0--������
1--��Ҫ��������
2--��������һ�����ϼ���
*/
$link_priority=array(
 'checkerror'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
// 'manage'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),	
// 'pass'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
// 'reject'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0), 
 'get'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'relate'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'bookmark'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'up'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'down'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'view'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'store'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'reporterr'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1)
);
//Ȩ�޼��
$ret=check_valid($op,$siteid,$item,$item['postuid'],'managelink',$link_priority);
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
include_once(S_ROOT.'./source/function_site.php');
if($op == 'get'){
	include_once(S_ROOT.'./source/every_todayhotcollect.php');
	include_once(S_ROOT.'./source/every_hotdigg.php');
	//�õ�siteclassname
	$item['classname']=getsiteclassname($item['class']);
	//�õ���site�����site
	$relatesites = getrelatesite($item['class'],$siteid);
	if(sizeof($relatesites)<$_SC['related_site_num'])
	{
		$needadd = $_SC['related_site_num']-sizeof($relatesites);
		for($i=0;$i<$needadd ;$i++){
			$relatesites[]=$todayhotcollect['site'][$i];
		}
	}
	//֧ȡtodayhotcollectǰ8��
	$hotsite = array_slice($relatesites, 0, 8);
/*
	$big_nums = 0;
	foreach($item['relate'] as $key=>$v){
		$item['bigrelate'][$key] = $item['relate'][$key];
		unset($item['relate'][$key]);
		//ȡ��ǰ3����Ϊbig relate
		if((++$big_nums)>=$_SC['related_big_site_num'])
			break;
	}
*/
	//��ȡhotclass
	//$hotclass = unserialize(sreadfile(S_ROOT.'./data/todayhotclass.txt'));
	//$hottag = unserialize(sreadfile(S_ROOT.'./data/todayhottag.txt'));
}
elseif($op == 'edit'){
		//����edit�ύ
		if(submitcheck('editsubmit')) {
			$item = site_post($_POST, $item);
			if(is_array($item)) {
				showmessage('do_success',$_SGLOBAL['refer']);
			} elseif($item) {
				showmessage('do_error');
			}
		}
}
elseif($op == 'relate'){
		$relatedlist[]=$item;		
}
elseif($_GET['op'] == 'delete') {
	//ɾ��
	if(submitcheck('deletesubmit')) {
		if(deletelink($siteid)) {
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
}elseif($_GET['op']=='up'){
		if(updatestatistic('site','up',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid'])))
			showmessage($item['up']+1);
		else{
			$errstr=$item['up'];
			include_once template("message");
			return;
		}

}elseif($_GET['op']=='down'){
        if(updatestatistic('site','down',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid'])))
			showmessage($item['down']+1);
		else{
			$errstr=$item['down'];
			include_once template("message");
			return;
		}

}elseif($_GET['op']=='view'){
        updatestatistic('site','viewnum',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid']));
		showmessage($item['viewnum']+1);
}elseif($_GET['op']=='store'){
	  updatesitestorenum($item['siteid'],1);
	  exit();
}elseif($_GET['op']=='reporterr'){
		//�ٱ�����
		  include_once(S_ROOT.'./data/data_siteerrtype.php');
		  if(submitcheck('errsubmit')) {
			//��֤��
			if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
				showmessage('incorrect_code');
			}
			$ret = siteerr_post($_POST, $item);
			if($ret) {	
				showmessage('do_success',$_SGLOBAL[refer]);
			} else{
				showmessage('that_should_at_least_write_things');
			}
		}
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
		$query  = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linkerr')." main left join ".tname("link")." field on main.siteid=field.siteid ".$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);
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


}elseif($_GET['op']=='bookmark'){
/*
	if(submitcheck('bookmarksubmit')) {
	}
*/
	$browserid=gethttpbrowserid(); 
}else {
	 if(submitcheck('addsubmit')) {
		 //��¼վ��
		if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
			showmessage('incorrect_code');
		}
		include_once(S_ROOT.'./source/function_site.php');
		$item = announce_post($_POST);
		exit();
	}
	//��ӱ༭
	//�����ϰ��õ�tag�е�,ȥ��
	/*
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//��ȡ���õ�tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	*/
}

include_once template("cp_site");

?>
