<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//添加书签
function linkclass_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET,$op;
	//操作者角色切换
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
	
	//检查是否也存在
	if($_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT uid FROM ".tname('linkclass')." WHERE parentid= ".$olds['groupid']." AND classname='".$POST['classname']."'"),0))
	{
			return false;
	}
	//获取最大groupid
	  $maxgrouid=0;

	  //确实是2层还是3层
	  if($olds['groupid']<2000)//第二层
	  {
		  $maxgrouid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT MAX(groupid) FROM ".tname('linkclass')." WHERE parentid<2000 "),0);
			 if(empty($maxgrouid))
				$maxgrouid=2000;
			else
				$maxgrouid=$maxgrouid+1;

	  }else{
		  //第三层
		  //获取最大groupid
			$maxgrouid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT MAX(groupid) FROM ".tname('linkclass')." WHERE parentid= ".$olds['groupid']),0);
			 if(empty($maxgrouid))
			$maxgrouid=3000;
			else
		    $maxgrouid=$maxgrouid+1;
	  }

	 

	//主表
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

	//角色切换
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $linkclassarr;
}

function deletelinkclass($classid){
	//处理link
	 global $_SGLOBAL;
	$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkclass')." main  WHERE classid= ".$classid);
	$linkclass=$_SGLOBAL['db']->fetch_array($query);
	if(empty($linkclass))
		return 0;
	//处理子类
	{
		$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkclass')." main  WHERE parentid= ".$linkclass['groupid']);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
		   deletelinkclass($value['classid']);
		}
	}
	//处理bookmark
	$_SGLOBAL['db']->query("DELETE  from ".tname('linkclass')." WHERE classid=".$classid);
	return 1;
}

?>
