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

	$classid= empty($_GET['classid'])?0:intval(trim($_GET['classid']));
	$groupid=0;
	//获取class分类
	$class_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=0");
	while($value =$_SGLOBAL['db']->fetch_array($class_query))
	{
		//获取二级目录
		$classnd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$value['groupid']);
		while($classnd_value =$_SGLOBAL['db']->fetch_array($classnd_query))
		{

				
			/*
			//获取三级目录
			$classrd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$classnd_value['groupid']);
			while($classrd_value =$_SGLOBAL['db']->fetch_array($classrd_query))
			{
				
			
				$classnd_value['grandson'][]= $classrd_value;
				
			}
			*/
			//获取本层class的tag
			$classtag_query  = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('linkclass')." main	LEFT JOIN ".tname('linkclasstag')." field ON main.classid=field.classid  WHERE main.classid=".$classnd_value['classid']);
			while($classtag_value =$_SGLOBAL['db']->fetch_array($classtag_query))
			{
						$classnd_value['tag'][]= $classtag_value;
			}
			$value['son'][]=$classnd_value;
		}
		$linkclasslist[]=$value;
	}
	if($classid)
	{
			$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.classid=".$classid);
			$classitem = $_SGLOBAL['db']->fetch_array($query);
			if(empty($classitem))   $classid=0;
			else
				$groupid=$classitem['groupid'];
	}

	if($classid){

			//获取三级目录
			$classrd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$groupid);
			while($classrd_value =$_SGLOBAL['db']->fetch_array($classrd_query))
			{
				$manageclass['son'][]= $classrd_value;				
			}
			//获取本层class的tag
			$classtag_query  = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('linkclass')." main	LEFT JOIN ".tname('linkclasstag')." field ON main.classid=field.classid  WHERE main.classid=".$classid);
			while($classtag_value =$_SGLOBAL['db']->fetch_array($classtag_query))
			{
						$manageclass['tag'][]= $classtag_value;
			}

	}
	else
		$manageclass= $linkclasslist[0]['son'][0];

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