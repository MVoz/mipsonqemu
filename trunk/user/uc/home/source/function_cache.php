<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_cache.php 13175 2009-08-17 01:23:43Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//更新配置文件
function config_cache($updatedata=true) {
	global $_SGLOBAL;

	$_SCONFIG = array();
	$query = $_SGLOBAL['db']->query('SELECT * FROM '.tname('config'));
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		if($value['var'] == 'privacy') {
			$value['datavalue'] = empty($value['datavalue'])?array():unserialize($value['datavalue']);
		}
		$_SCONFIG[$value['var']] = $value['datavalue'];
	}
	cache_write('config', '_SCONFIG', $_SCONFIG);

	if($updatedata) {
		$setting = data_get('setting');
		$_SGLOBAL['setting'] = empty($setting)?array():unserialize($setting);
		cache_write('setting', "_SGLOBAL['setting']", $_SGLOBAL['setting']);

		$mail = data_get('mail');
		$_SGLOBAL['mail'] = empty($mail)?array():unserialize($mail);
		cache_write('mail', "_SGLOBAL['mail']", $_SGLOBAL['mail']);

		$spam = data_get('spam');
		$_SGLOBAL['spam'] = empty($spam)?array():unserialize($spam);
		cache_write('spam', "_SGLOBAL['spam']", $_SGLOBAL['spam']);
	}
}

//更新network配置文件
function network_cache() {
	global $_SGLOBAL, $_SCONFIG;

	$setting = data_get('network');
	$_SGLOBAL['network'] = empty($setting)?array():unserialize($setting);
	cache_write('network', "_SGLOBAL['network']", $_SGLOBAL['network']);
}

//更新用户组CACHE
function usergroup_cache() {
	global $_SGLOBAL;

	$usergroup = $_SGLOBAL['grouptitle'] = array();
	$highest = true;
	$lower = '';
	$query = $_SGLOBAL['db']->query('SELECT * FROM '.tname('usergroup')." ORDER BY explower DESC");
	while ($group = $_SGLOBAL['db']->fetch_array($query)) {
		$group['maxattachsize'] = $group['maxattachsize'] * 1024 * 1024;//M
		if($group['system'] == 0) {
			//是否是最高上限
			if($highest) {
				$group['exphigher'] = 999999999;
				$highest = false;
				$lower = $group['explower'];
			} else {
				$group['exphigher'] = $lower - 1;
				$lower = $group['explower'];
			}
		}
		$group['magicaward'] = unserialize($group['magicaward']);
		
		$usergroup = array($group['gid'] => $group);
		
		$_SGLOBAL['grouptitle'][$group['gid']] = array(
			'grouptitle' => $group['grouptitle'],
			'color' => $group['color'],
			'icon' => $group['icon']
		);
		
		//生成缓存文件
		cache_write('usergroup_'.$group['gid'], "_SGLOBAL['usergroup']", $usergroup);
	}
	
	//生成缓存文件
	cache_write('usergroup', "_SGLOBAL['grouptitle']", $_SGLOBAL['grouptitle']);

}

//更新用户栏目缓存
function profilefield_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['profilefield'] = array();
	$query = $_SGLOBAL['db']->query('SELECT fieldid, title, formtype, maxsize, required, invisible, allowsearch, choice FROM '.tname('profilefield')." ORDER BY displayorder");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['profilefield'][$value['fieldid']] = $value;
	}
	cache_write('profilefield', "_SGLOBAL['profilefield']", $_SGLOBAL['profilefield']);
}

//更新群组栏目缓存
function profield_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['profield'] = array();
	$query = $_SGLOBAL['db']->query('SELECT fieldid, title, formtype, inputnum, mtagminnum, manualmoderator, manualmember FROM '.tname('profield')." ORDER BY displayorder");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['profield'][$value['fieldid']] = $value;
	}
	cache_write('profield', "_SGLOBAL['profield']", $_SGLOBAL['profield']);
}

//更新词语屏蔽
function censor_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['censor'] = $banned = $banwords = array();

	$censorarr = explode("\n", data_get('censor'));
	foreach($censorarr as $censor) {
		$censor = trim($censor);
		if(empty($censor)) continue;

		list($find, $replace) = explode('=', $censor);
		$findword = $find;
		$find = preg_replace("/\\\{(\d+)\\\}/", ".{0,\\1}", preg_quote($find, '/'));
		switch($replace) {
			case '{BANNED}':
				$banwords[] = preg_replace("/\\\{(\d+)\\\}/", "*", preg_quote($findword, '/'));
				$banned[] = $find;
				break;
			default:
				$_SGLOBAL['censor']['filter']['find'][] = '/'.$find.'/i';
				$_SGLOBAL['censor']['filter']['replace'][] = $replace;
				break;
		}
	}
	if($banned) {
		$_SGLOBAL['censor']['banned'] = '/('.implode('|', $banned).')/i';
		$_SGLOBAL['censor']['banword'] = implode(', ', $banwords);
	}

	cache_write('censor', "_SGLOBAL['censor']", $_SGLOBAL['censor']);
}

//更新积分规则
function creditrule_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['creditrule'] = array();

	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('creditrule'));
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['creditrule'][$value['action']] = $value;
	}
	cache_write('creditrule', "_SGLOBAL['creditrule']", $_SGLOBAL['creditrule']);
}

//更新广告缓存
function ad_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['ad'] = array();
	$query = $_SGLOBAL['db']->query('SELECT adid, pagetype FROM '.tname('ad')." WHERE system='1' AND available='1'");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['ad'][$value['pagetype']][] = $value['adid'];
	}
	cache_write('ad', "_SGLOBAL['ad']", $_SGLOBAL['ad']);
}

//更新用户向导任务
function task_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['task'] = array();
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('task')." WHERE available='1' ORDER BY displayorder");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		if((empty($value['endtime']) || $value['endtime'] >= $_SGLOBAL['timestamp']) && (empty($value['maxnum']) || $value['maxnum']>$value['num'])) {
			$_SGLOBAL['task'][$value['taskid']] = $value;
		}
	}
	cache_write('task', "_SGLOBAL['task']", $_SGLOBAL['task']);
}

//更新点击器
function click_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['click'] = array();
	$query = $_SGLOBAL['db']->query('SELECT * FROM '.tname('click')." ORDER BY displayorder");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['click'][$value['idtype']][$value['clickid']] = $value;
	}
	cache_write('click', "_SGLOBAL['click']", $_SGLOBAL['click']);
}

//更新模块
function block_cache() {
	global $_SGLOBAL;

	$_SGLOBAL['block'] = array();
	$query = $_SGLOBAL['db']->query('SELECT bid, cachetime FROM '.tname('block'));
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$_SGLOBAL['block'][$value['bid']] = $value['cachetime'];
	}
	cache_write('block', "_SGLOBAL['block']", $_SGLOBAL['block']);
}

//更新模板文件
function tpl_cache() {
	include_once(S_ROOT.'./source/function_cp.php');

	$dir = S_ROOT.'./data/tpl_cache';
	$files = sreaddir($dir);
	foreach ($files as $file) {
		@unlink($dir.'/'.$file);
	}
}

//更新模块缓存
function block_data_cache() {
	global $_SGLOBAL, $_SCONFIG;

	if($_SCONFIG['cachemode'] == 'database') {
		$query = $_SGLOBAL['db']->query("SHOW TABLE STATUS LIKE '".tname('cache')."%'");
		while($table = $_SGLOBAL['db']->fetch_array($query)) {
			$_SGLOBAL['db']->query("TRUNCATE TABLE `$table[Name]`");
		}
	} else {
		include_once(S_ROOT.'./source/function_cp.php');
		deltreedir(S_ROOT.'./data/block_cache');
	}
}

//更新MYOP默认应用
function userapp_cache() {
	global $_SGLOBAL, $_SCONFIG;

	$_SGLOBAL['userapp'] = array();
	if($_SCONFIG['my_status']) {
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('myapp')." WHERE flag='1' ORDER BY displayorder", 'SILENT');
		while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			$_SGLOBAL['userapp'][$value['appid']] = $value;
		}
	}
	cache_write('userapp', "_SGLOBAL['userapp']", $_SGLOBAL['userapp']);
}

//更新应用名
function app_cache() {
	global $_SGLOBAL;

	$relatedtag = unserialize(data_get('relatedtag'));
	$default_open = 0;
	if(empty($relatedtag)) {
		//从UC取应用
		$relatedtag = array();
		include_once S_ROOT.'./uc_client/client.php';
		$relatedtag['data'] = uc_app_ls();
		$default_open = 1;
	}

	$_SGLOBAL['app'] = array();
	foreach($relatedtag['data'] as $appid => $data) {
		if($default_open) {
			$data['open'] = 1;
		}
		if($appid == UC_APPID) {//当前应用
			$data['open'] = 0;
		}
		$_SGLOBAL['app'][$appid] = array(
			'name' => $data['name'],
			'url' => $data['url'],
			'type' => $data['type'],
			'open'=>$data['open'],
			'icon' => $data['type']=='OTHER'?'default':strtolower($data['type'])
			);
	}
	cache_write('app', "_SGLOBAL['app']", $_SGLOBAL['app']);
}

// 更新活动分类
function eventclass_cache(){
    global $_SGLOBAL;

	$_SGLOBAL['eventclass'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT * FROM " . tname("eventclass") . " ORDER BY displayorder");
	while($value = $_SGLOBAL['db']->fetch_array($query)){
		if($value['poster']) {
			$value['poster'] = "data/event/".$value['classid'].".jpg";
		} else {
			$value['poster'] = "image/event/default.jpg";
		}
	    $_SGLOBAL['eventclass'][$value['classid']] = $value;
	}
	cache_write('eventclass', "_SGLOBAL['eventclass']", $_SGLOBAL['eventclass']);
}

//更新道具信息
function magic_cache(){
    global $_SGLOBAL;

	$_SGLOBAL['magic'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT mid, name FROM ".tname('magic')." WHERE close='0'");
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['magic'][$value['mid']] = $value['name'];
	}
	cache_write('magic', "_SGLOBAL['magic']", $_SGLOBAL['magic']);
}
//更新link错误类型
function linkerrtype_cache(){
	global $_SGLOBAL;

	$_SGLOBAL['linkerrtype'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT errid, errname FROM ".tname('linkerrtype'));
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['linkerrtype'][$value['errid']] = $value['errname'];
	}
	cache_write('linkerrtype', "_SGLOBAL['linkerrtype']", $_SGLOBAL['linkerrtype']);
}
//更新digg ategory类型
function diggcategory_cache(){
	global $_SGLOBAL;

	$_SGLOBAL['diggcategory'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT categoryid, categoryname ,categoryalias FROM ".tname('diggcategory'));
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['diggcategory'][$value['categoryid']]['categoryname'] = $value['categoryname'];
		$_SGLOBAL['diggcategory'][$value['categoryid']]['categoryalias'] = $value['categoryalias'];
	}
	cache_write('diggcategory', "_SGLOBAL['diggcategory']", $_SGLOBAL['diggcategory']);
}
//更新浏览器类型 
function browsertype_cache(){
	global $_SGLOBAL;

	$_SGLOBAL['browsertype'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT browserid, browsername FROM ".tname('browser'));
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['browsertype'][$value['browsername']] = $value['browserid'];
	}
	cache_write('browsertype', "_SGLOBAL['browsertype']", $_SGLOBAL['browsertype']);
}
//hotdigglist
function hotdigg_cache()
{
	global $_SGLOBAL;

	$_SGLOBAL['hotdigg'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('digg')." order by viewnum DESC limit 0,10");
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['hotdigg'][] = $value;
	}
	cache_write('hotdigg', "_SGLOBAL['hotdigg']", $_SGLOBAL['hotdigg']);
}
//linktoolbartype
function linktoolbartype_cache()
{
	global $_SGLOBAL;

	$_SGLOBAL['linktoolbartype'] = array();
	// 从数据库获取
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linktoolbartype'));
	while($value = $_SGLOBAL['db']->fetch_array($query)){
	    $_SGLOBAL['linktoolbartype'][$value[id]] = $value[toolbarname];
	}
	cache_write('linktoolbartype', "_SGLOBAL['linktoolbartype']", $_SGLOBAL['linktoolbartype']);
}
//linktoolbar
function linktoolbar_cache()
{
	global $_SGLOBAL;

	$_SGLOBAL['linktoolbar'] = array();
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linktoolbartype'));
	while($value = $_SGLOBAL['db']->fetch_array($query)){
		// 从数据库获取
		$q = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linktoolbar')." where classid=".$value[id]);	 
		while($v = $_SGLOBAL['db']->fetch_array($q)){
			$_SGLOBAL['linktoolbar'][$value[id]][] = $v;
		}
	}
	cache_write('linktoolbar', "_SGLOBAL['linktoolbar']", $_SGLOBAL['linktoolbar']);
}
//linkclass	
function linkclass_cache()
{
	global $_SGLOBAL;

	$_SGLOBAL['linkclass'] = array();

	$class_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=0");
	while($value =$_SGLOBAL['db']->fetch_array($class_query))
	{
		//获取二级目录
		$classnd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$value['groupid']);
		while($classnd_value =$_SGLOBAL['db']->fetch_array($classnd_query))
		{			
		
			//获取本层class的tag
			
			$classtag_query  = $_SGLOBAL['db']->query("SELECT field.tagid,field.tagname FROM ".tname('linkclass')." main	LEFT JOIN ".tname('linkclasstag')." field ON main.classid=field.classid  WHERE main.classid=".$classnd_value['classid']);
			while($classtag_value =$_SGLOBAL['db']->fetch_array($classtag_query))
			{
						$classnd_value['tag'][]= $classtag_value;
			}
			
			$value['son'][]=$classnd_value;
		}
		$_SGLOBAL['linkclass'][$value['classid']]=$value;
	}




	cache_write('linkclass', "_SGLOBAL['linkclass']", $_SGLOBAL['linkclass']);
}
/*user bookmarkcache*/
function bookmark_cache_group($groupid,$browserid)
{
		global $_SGLOBAL;
		$bookmarklist=array();
		$bmcachefileprefix = S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark';
		$query  = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." field on main.linkid=field.linkid  WHERE main.uid=".$_SGLOBAL['supe_uid']." and main.browserid=".$browserid." and main.parentid=".$groupid);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			//检查目录
			if(!empty($value['type']))
			{
				 bookmark_cache_group($value['groupid'],$browserid);
				 continue;
			}
			$bookmarklist[]=$value;
		}
		$bookmarklist['count']=count($bookmarklist);
		swritefile($bmcachefileprefix.'_'.$browserid.'_'.$groupid.'.txt', serialize($bookmarklist));
}
function bookmark_cache()
{
	global $_SGLOBAL;
	$groupid=0;
	if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid']))
	{
		mkdir(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'], 0777);	
	}
	$bmcachefileprefix = S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark';	
	foreach($_SGLOBAL['browsertype'] as $k=>$v)
	{
		$bookmarklist=array();
		$query  = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." field on main.linkid=field.linkid  WHERE main.uid=".$_SGLOBAL['supe_uid']." and main.browserid=".$v." and main.parentid=".$groupid);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			//检查目录
			if(!empty($value['type']))
			{
				 bookmark_cache_group($value['groupid'],$v);
				 continue;
			}
			$bookmarklist[]=$value;
		}
		$bookmarklist['count']=count($bookmarklist);
		swritefile($bmcachefileprefix.'_'.$v.'_'.$groupid.'.txt', serialize($bookmarklist));

	}
}
//书签组名字的缓存
function bookmark_groupname_cache()
{
	global $_SGLOBAL,$_SC;
	$groupid=0;
	if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid']))
	{
		mkdir(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'], 0777);	
	}
	$bmcachefileprefix = S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_groupname';	
	$grouplist=array();
	foreach($_SGLOBAL['browsertype'] as $k=>$v)
	{
		
		$query  = $_SGLOBAL['db']->query("SELECT groupid,subject FROM ".tname('bookmark')." main WHERE main.uid=".$_SGLOBAL['supe_uid']." and main.browserid=".$v." and main.type=".$_SC['bookmark_type_dir']);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			$grouplist[$v][$value['groupid']]=getstr($value['subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
		}

	}
	cache_write_extend('bookmark_groupname', "_SGLOBAL['bookmark_groupname']", $grouplist);
} 
//用户菜单缓存
function usermenu_cache_group($browserid,$groupid)
{
	global $_SGLOBAL,$_SC;
	$arr=array();
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=".$groupid.' AND browserid='.$browserid);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			$value['son']=usermenu_cache_group($browserid,$value['groupid'],$value);
			$arr[]=$value;
		}
		return $arr;
}
function usermenu_cache()
{
	global $_SGLOBAL,$_SC;
	$groupid=0;
	if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid']))
	{
		mkdir(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'], 0777);	
	}
	$usermenulist=array();
	foreach($_SGLOBAL['browsertype'] as $k=>$v)
	{
		
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=".$groupid.' AND browserid='.$v);
		while($value =$_SGLOBAL['db']->fetch_array($query))
		{
			$value['son']=usermenu_cache_group($v,$value['groupid']);
			$usermenulist[$v][$groupid][]=$value;
			
		}
		cache_write_extend('usermenu', "_SGLOBAL['usermenu']", $usermenulist);
	}
}
//link cache
function link_cache_classid($classid)
{
	global $_SGLOBAL,$_SC;
	if(!file_exists(S_ROOT.'./data/linkcache/'.$classid))
	{
		mkdir(S_ROOT.'./data/linkcache/'.$classid, 0777);	
	}
	$linkfileprefix = S_ROOT.'./data/linkcache/'.$classid.'/link_cache';	
	$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." main where main.classid=".$classid),0);

	//$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main where main.classid=".$classid." limit ".$start." , ".$_SC['bookmark_show_maxnum']);
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main where main.classid=".$classid);	
	$page=1;
	$linklist=array();
	while($value =$_SGLOBAL['db']->fetch_array($query))
	{
		
		$value['description'] = getstr($value['link_description'], $_SC['description_nbox_title_length'], 0, 0, 0, 0, -1);
		$value['subject'] = getstr($value['link_subject'], $_SC['subject_nbox_title_length'], 0, 0, 0, 0, -1);
		$linklist[]=$value;
		if(count($linklist)==$_SC['bookmark_show_maxnum'])
		{
			swritefile($linkfileprefix.'_'.$classid.'_page'.$page.'.txt', serialize($linklist));
			$page++;
			$linklist=array();
		}
	}
	swritefile($linkfileprefix.'_'.$classid.'_page'.$page.'.txt', serialize($linklist));
	swritefile($linkfileprefix.'_'.$classid.'_count.txt', $count) ;
}
function link_cache()
{
   global $_SGLOBAL,$_SC;
   $query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main where main.groupid>=2000");	
   while($value =$_SGLOBAL['db']->fetch_array($query))
	{
	   link_cache_classid($value['classid']);
	}
}
//每日推荐
function everydayhot_cache()
{
	global $_SGLOBAL,$_SC;
	$todayhot = array();
	//$todayhotlist = array();

	//获得link的统计数
	//$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." main where //main.origin=$_SC['link_origin_link']"),0);

	$_SCONFIG['todayhot']=array(1,2,3,4);
	$todayhotid = sarray_rand($_SCONFIG['todayhot'], 1);
	foreach($todayhotid as $key=>$val){
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." WHERE linkid=$val");
		while ($value = $_SGLOBAL['db']->fetch_array($query)) {
				$value['link_short_subject'] = getstr(trim($value['link_subject']), $_SC['subject_todayhot_length']);	
				$value['link_short_description'] = getstr(trim($value['link_description']), $_SC['description_todayhot_length']);
				include_once(S_ROOT.'./source/function_link.php');
				$value['link_tag'] = convertlinktag($value['linkid'],$value['link_tag']);
				$value['link_tag'] = empty($value['link_tag'])?array():unserialize($value['link_tag']);
				$todayhot= $value;
		}	
	}
	swritefile( S_ROOT.'./data/todayhot.txt', serialize($todayhot));
}
//递归清空目录
function deltreedir($dir) {
	$files = sreaddir($dir);
	foreach ($files as $file) {
		if(is_dir("$dir/$file")) {
			deltreedir("$dir/$file");
		} else {
			@unlink("$dir/$file");
		}
	}
}

//数组转换成字串
function arrayeval($array, $level = 0) {
	$space = '';
	for($i = 0; $i <= $level; $i++) {
		$space .= "\t";
	}
	$evaluate = "Array\n$space(\n";
	$comma = $space;
	foreach($array as $key => $val) {
		$key = is_string($key) ? '\''.addcslashes($key, '\'\\').'\'' : $key;
		$val = !is_array($val) && (!preg_match("/^\-?\d+$/", $val) || strlen($val) > 12 || substr($val, 0, 1)=='0') ? '\''.addcslashes($val, '\'\\').'\'' : $val;
		if(is_array($val)) {
			$evaluate .= "$comma$key => ".arrayeval($val, $level + 1);
		} else {
			$evaluate .= "$comma$key => $val";
		}
		$comma = ",\n$space";
	}
	$evaluate .= "\n$space)";
	return $evaluate;
}

//写入
function cache_write($name, $var, $values) {
	$cachefile = S_ROOT.'./data/data_'.$name.'.php';
	$cachetext = "<?php\r\n".
		"if(!defined('IN_UCHOME')) exit('Access Denied');\r\n".
		'$'.$var.'='.arrayeval($values).
		"\r\n?>";
	if(!swritefile($cachefile, $cachetext)) {
		exit("File: $cachefile write error.");
	}
}
//add by ramen to extend
function cache_write_extend($name, $var, $values) {
	global $_SGLOBAL,$_SC;
	if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid']))
	{
		mkdir(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'], 0777);	
	}
	$cachefile = S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/'.$name.'.php';
	$cachetext = "<?php\r\n".
		"if(!defined('IN_UCHOME')) exit('Access Denied');\r\n".
		'$'.$var.'='.arrayeval($values).
		"\r\n?>";
	if(!swritefile($cachefile, $cachetext)) {
		exit("File: $cachefile write error.");
	}
}
?>