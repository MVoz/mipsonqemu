<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: admincp_tag.php 12568 2009-07-08 07:38:01Z zhengqingpeng $
*/

if(!defined('IN_UCHOME') || !defined('IN_ADMINCP')) {
	exit('Access Denied');
}

//权限
if(!checkperm('managetag')) {
	cpmessage('no_authority_management_operation');
}

if(submitcheck('linksubmit')) {
	
	$linkid = intval($_POST['linkid']);
	echo $linkid;
	if(empty($linkid)||empty($_POST['subject'])||empty($_POST['address'])) {
		cpmessage('please_check_whether_the_option_complete_required');
	}
	/*
	$_POST['up'] =empty($_POST['up'])?0:intval($_POST['up']);
	$_POST['down'] =empty($_POST['down'])?0:intval($_POST['down']);
	$_POST['initaward'] =empty($_POST['initaward'])?0:intval($_POST['initaward']);
	$_POST['initaward'] = getinitaward($_POST['initaward']);

	$_POST['subject'] = getstr($_POST['subject'], 50, 1, 1);
	$_POST['url'] = shtmlspecialchars(trim($_POST['address']));
	$_POST['url'] = getstr($_POST['url'], 1024, 1, 1, 1);	//语词屏蔽
	$_POST['description'] = getstr($_POST['description'], 512, 1, 1);
	



	$setarr = array(
		'subject' => $_POST['subject'],
		'url' => $_POST['url'],
		'description' => $_POST['description'],
		'up' => $_POST['up'],
		'down' => $_POST['down'],
		'initaward' => $_POST['initaward']
	);
	
	if(empty($linkid)) {
		$adid = inserttable('link', $setarr, 1);
	} else {
		updatetable('link', $setarr, array('linkid' => $linkid));
	}
	*/
	include_once(S_ROOT.'./source/function_link.php');
	$item = getlink($linkid);
	link_post($_POST,$item);
	//去除缓存更新
	updatelinkinfo($linkid);

	//增加editflag
	$editflag = $item['editflag']+1;
	updatetable('link',array('editflag'=>$editflag), array('linkid'=>$linkid));

	cpmessage('do_success', 'admincp.php?ac=link');
}
if(empty($_GET['op'])) {
	$mpurl = 'admincp.php?ac=link';

	//处理搜索
	/*
	$intkeys = array('close');
	$strkeys = array();
	$randkeys = array(array('sstrtotime','dateline'), array('intval','blognum'));
	$likekeys = array('tagname');
	$results = getwheres($intkeys, $strkeys, $randkeys, $likekeys);
	$wherearr = $results['wherearr'];
	*/
	$wheresql = empty($wherearr)?'1':implode(' AND ', $wherearr);
	
	$editflag = empty($_GET['edit'])?0:intval($_GET['edit']);
	$wheresql = " siteid=0 and picflag=1 and editflag=".$editflag ;

	$mpurl .= '&'.implode('&', $results['urls']);

	//排序
	$orders = getorders(array('dateline', 'storenum'), 'linkid');
	$ordersql = $orders['sql'];
	if($orders['urls']) $mpurl .= '&'.implode('&', $orders['urls']);
	$orderby = array($_GET['orderby']=>' selected');
	$ordersc = array($_GET['ordersc']=>' selected');

	//显示分页
	$perpage = empty($_GET['perpage'])?0:intval($_GET['perpage']);
	if(!in_array($perpage, array(20,50,100))) $perpage = 20;
	$mpurl .= '&perpage='.$perpage;
	$perpages = array($perpage => ' selected');

	$page = empty($_GET['page'])?1:intval($_GET['page']);
	if($page<1) $page = 1;
	$start = ($page-1)*$perpage;
	//检查开始数
	ckstart($start, $perpage);
	$managebatch = checkperm('managebatch');
	$allowbatch = true;
	$list = array();
	$multi = '';

	$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." WHERE $wheresql"), 0);
	if($count) {
		$query = $_SGLOBAL['db']->query("SELECT linkid FROM ".tname('link')." WHERE $wheresql $ordersql LIMIT $start,$perpage");
		while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			$list[] = getlink($value['linkid']);
		}
		$multi = multi($count, $perpage, $page, $mpurl);
	}
}elseif ($_GET['op'] == 'edit') {
		$linkid = empty($_GET['linkid'])?0:intval($_GET['linkid']);

		$item = array();
		if($linkid ) {
			$item = getlink($linkid);
		}
}
?>