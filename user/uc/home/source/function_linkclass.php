<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//�����ǩ
function linkclass_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET,$op;
	//�����߽�ɫ�л�
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//tag
	$POST['classname'] = getstr(trim($POST['classname']), 80, 1, 1, 1);	 
	if(empty($POST['classname'])) {
		return false;
	}		
	
	//����Ƿ�Ҳ����
	if($_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT uid FROM ".tname('linkclass')." WHERE parentid= ".$olds['groupid']." AND classname='".$POST['classname']."'"),0))
	{
			return false;
	}
	//��ȡ���groupid
	  $maxgrouid=0;

	  //ȷʵ��2�㻹��3��
	  if($olds['groupid']<2000)//�ڶ���
	  {
		  $maxgrouid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT MAX(groupid) FROM ".tname('linkclass')." WHERE parentid<2000 "),0);
			 if(empty($maxgrouid))
				$maxgrouid=2000;
			else
				$maxgrouid=$maxgrouid+1;

	  }else{
		  //������
		  //��ȡ���groupid
			$maxgrouid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT MAX(groupid) FROM ".tname('linkclass')." WHERE parentid= ".$olds['groupid']),0);
			 if(empty($maxgrouid))
			$maxgrouid=3000;
			else
		    $maxgrouid=$maxgrouid+1;
	  }

	 

	//����
	$linkclassarr = array(
		'classname' => $POST['classname'],
		'groupid'	=> $maxgrouid,
		'parentid'=>$olds['groupid'],
		'uid' => $_SGLOBAL['supe_uid'],
		'dateline' => empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline']
	);
	if($op=='add'){
			$bmid = inserttable('linkclass', $linkclassarr, 1);
	}else{			
			updatetable('linkclass', $linkclassarr, array('tagid'=>$olds['tagid']));
	}						

	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $linkclassarr;
}

function deletelinkclass($classid){
	//����link
	 global $_SGLOBAL;
	$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkclass')." main  WHERE classid= ".$classid);
	$linkclass=$_SGLOBAL['db']->fetch_array($query);
	if(empty($linkclass))
		return 0;
	//��������
	{
		$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkclass')." main  WHERE parentid= ".$linkclass['groupid']);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
		   deletelinkclass($value['classid']);
		}
	}
	//����bookmark
	$_SGLOBAL['db']->query("DELETE  from ".tname('linkclass')." WHERE classid=".$classid);
	return 1;
}

?>
