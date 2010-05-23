<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: admincp_ad.php 11954 2009-04-17 09:29:53Z liguode $
*/

if(!defined('IN_UCHOME') || !defined('IN_ADMINCP')) {
	exit('Access Denied');
}

//权限
if(!checkperm('managead')) {
	cpmessage('no_authority_management_operation');
}

if(submitcheck('linktoolbarsubmit')) {

	$linktoolbarid = intval($_POST['linktoolbarid']);
	$_POST['subject'] = getstr($_POST['subject'], 50, 1, 1);
	$_POST['url'] = shtmlspecialchars(trim($_POST['address']));
	$_POST['url'] = getstr($_POST['url'], 1024, 1, 1, 1);	//语词屏蔽
	$_POST['description'] = getstr($_POST['description'], 250, 1, 1);

	

	if(empty($_POST['subject'])||empty($_POST['url'])) {
		cpmessage('please_check_whether_the_option_complete_required');
	} 

	$setarr = array(
		'subject' => $_POST['subject'],
		'url' => $_POST['url'],
		'description' => $_POST['description'],
		'classid' => empty($_POST['category'])?1:intval($_POST['category'])
	);

	if(empty($linktoolbarid)) {
		$adid = inserttable('linktoolbar', $setarr, 1);
	} else {
		updatetable('linktoolbar', $setarr, array('toolbarid' => $linktoolbarid));
	}

	//写入模板
//	$tpl = S_ROOT.'./data/adtpl/'.$adid.'.htm';
//	swritefile($tpl, $html);

	//缓存更新
	include_once(S_ROOT.'./source/function_cache.php');
	linktoolbar_cache();

	cpmessage('do_success', 'admincp.php?ac=linktoolbar');

} elseif(submitcheck('delsubmit')) {

	include_once(S_ROOT.'./source/function_delete.php');
	if(!empty($_POST['adids']) && deleteads($_POST['adids'])) {

		//缓存更新
		include_once(S_ROOT.'./source/function_cache.php');
		ad_cache();

		cpmessage('do_success', 'admincp.php?ac=ad');
	} else {
		cpmessage('please_choose_to_remove_advertisements', 'admincp.php?ac=ad');
	}

}

if(empty($_GET['op'])) {

	$sql = '';
	$list = array();
	foreach($_SGLOBAL['linktoolbartype'] as $key=>$val){
		$query = $_SGLOBAL['db']->query('SELECT * FROM '.tname('linktoolbar')." where classid= ".$key." ORDER BY toolbarid  DESC");
		while($value = $_SGLOBAL['db']->fetch_array($query)) {
			$list[$key][] = $value;
		}
	}
	$actives = array('view' => ' class="active"');

} elseif ($_GET['op'] == 'add' || $_GET['op'] == 'edit') {

	$_GET['linktoolbarid'] = empty($_GET['linktoolbarid'])?0:intval($_GET['linktoolbarid']);

	$linktoolbarvalue = array();
	if($_GET['linktoolbarid']) {
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linktoolbar')." WHERE toolbarid=$_GET[linktoolbarid]");
		$linktoolbarvalue = $_SGLOBAL['db']->fetch_array($query);
	}
	

	//显示处理
	$systems = array($advalue['system'] => ' checked');
	$pagetypes = array($advalue['pagetype'] => ' selected');
	$availables = array($advalue['available'] => ' checked');
	$adcodes = array($advalue['adcode']['type'] => ' selected');

} elseif ($_GET['op'] == 'tpl') {

	$adcode = shtmlspecialchars("<!--{template data/adtpl/$_GET[adid]}-->");

} elseif ($_GET['op'] == 'js') {

	$adcode = shtmlspecialchars("<script type=\"text/javascript\" src=\"".getsiteurl()."js.php?adid=$_GET[adid]\"></script>");

}

?>