<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//�����ǩ
function linkclasstag_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET,$op;
	//�����߽�ɫ�л�
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//tag
	$POST['tag'] = getstr(trim($POST['tag']), 80, 1, 1, 1);	 
	if(empty($POST['tag'])) {
		return false;
	}		
   
	//����
	$linkclasstagarr = array(
		'classid'=>$olds['classid'],
		'tagname' => $POST['tag'],
		'uid' => $_SGLOBAL['supe_uid'],
		'dateline' => empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline']
	);
	//����Ƿ�Ҳ����
	if($_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT uid FROM ".tname('linktagclass')." main  WHERE classid= ".$olds['classid']." AND tagname=".$POST['tag']),0)
	{
			return false;
	}

	if($op=='add'){
			$bmid = inserttable('linkclasstag', $linkclasstagarr, 1);
	}else{			
			updatetable('linkclasstag', $linkclasstagarr, array('tagid'=>$olds['tagid']));
	}						

	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $linkclasstagarr;
}

function deletelinkclasstag($tagid){
	//����link
	 global $_SGLOBAL;
	$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('linktagclass')." main  WHERE tagid= ".$tagid);
	$linkclasstag=$_SGLOBAL['db']->fetch_array($query);
	if(empty($linkclasstag))
		return 0;
	//����bookmark
	$_SGLOBAL['db']->query("DELETE  from ".tname('linktagclass')." WHERE tagid=".$tagid);
	return 1;
}

?>
