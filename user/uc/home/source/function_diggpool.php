<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
function publishdiggpool($diggpoolitem)
{
  if(empty($diggpoolitem))
	  return false;
  include_once(S_ROOT.'./source/function_digg.php');
  $diggpoolitem['picids'][$diggpoolitem['picflag']]=$diggpoolitem['picflag'];
  $diggpoolitem['address'] =  $diggpoolitem['url'];
  deletediggpool($diggpoolitem['diggpoolid']);
  digg_post($diggpoolitem);
  return true;
}
//添加diggpool
function diggpool_post($POST) {
	global $_SGLOBAL, $_SC, $space,$_GET;
	//操作者角色切换
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//标题
	$POST['subject'] = getstr(trim($POST['subject']), 80, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');
		
	//内容
	if($_SGLOBAL['mobile']) {
		$POST['description'] = getstr(trim($POST['description']), 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr(trim($POST['description']), 220, 1,1, 1);
	}
	//$message = $POST['description'];
	$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
	$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//语词屏蔽

	$POST['address'] = shtmlspecialchars(trim($POST['address']));
	$POST['address'] = getstr($POST['address'], 500, 1, 1, 1);	//语词屏蔽
	//主表
	$diggpoolarr = array(
		'subject' => $POST['subject'],	
		'postuid' => $_SGLOBAL['supe_uid'],
		'username'=> $_SGLOBAL['name'],
		'description' => $POST['description'],
		'url'=>$POST['address'],
		'tag'=>$POST['tag'],
		'hashurl'=>qhash($POST['address']),
		'md5url'=>md5($POST['address']),
	);
	$diggpoolarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];

	if(!empty($POST['picids'])) {
		$picids = array_keys($POST['picids']);
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('pic')." WHERE picid IN (".simplode($picids).") AND uid='$_SGLOBAL[supe_uid]'");
		if ($value = $_SGLOBAL['db']->fetch_array($query)) {
			if(empty($titlepic) && $value['thumb']) {
				$diggpoolarr['picflag'] = $$picids[0];
			}
			$diggpoolarr['pic'] = pic_get($value['filepath'], $value['thumb'], $value['remote'], 1);
		}
		if(empty($titlepic) && $value) {
			$diggpoolarr['picflag'] = $picids[0];
		}
	} 

	//检查是否已存在
	if(!is_diggpool_exist($diggpoolarr['url'])){
		$diggid = inserttable('diggpool', $diggpoolarr, 1);
	}else{
		showmessage('diggpool_is_existed');
	}

	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $diggpoolarr;
}

function deletediggpool($diggpoolid){
	global $_SGLOBAL;
	$_SGLOBAL['db']->query("DELETE  from ".tname('diggpool')." WHERE diggpoolid=".$diggpoolid);
	return 1;
}
function is_diggpool_exist($url)
{
	global $_SGLOBAL;
	if(strlen($url)){
			$hashurl=qhash($url); 
			$md5url=md5($url);
			$diggid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT diggpoolid FROM ".tname('diggpool')." WHERE hashurl=".$hashurl." AND md5url='".$md5url."'"));
			if(!empty($diggid))
				return true;
	}
	return false;
}			
?>
