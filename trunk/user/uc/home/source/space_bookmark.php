<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//是否公开
if(empty($_SCONFIG['networkpublic'])) {
	checklogin();//需要登录
}
/*
$acs = array('space', 'doing', 'blog', 'album', 'mtag', 'thread', 'share');
$ac = (empty($_GET['ac']) || !in_array($_GET['ac'], $acs))?'index':$_GET['ac'];

if(!empty($ac)){
	include_once(S_ROOT.'./source/network_{$ac}.php');
	include_once template('network_'.$ac);
	
}else{
*/
include_once(S_ROOT.'./data/data_network.php');

//日志
     $viewstr=array(
            'lastvisit'=>'lastvisit',
                'lastadd'=>'dateline',
                'oftenvisit'=>'visitnums',
                'lastrecommend'=>'lastvisit'
            );
;
	//显示数量
	$shownum = 6;
    //$userbrowertype=getuserbrowserarray();
    //显示类别如最近访问，最新添加etc...
    $see=empty($_GET['see'])?'':$_GET['see'];
    //浏览器类型
    $browserid=(empty($_GET['browserid']))?$browsertype['ie']:intval($_GET['browserid']);
    if(!in_array($browserid,$browsertype))
        $browserid=$browsertype['ie'];
	$groupid=isset ($_GET['groupid'])?intval($_GET['groupid']):'-1';
    if(!empty($see))//以$see为主
    {
        $groupid=-1;
         
        if(!in_array($see,array_keys($viewstr)))
            $see=$viewstr['lastvisit'];
        else
            $see=$viewstr[$see];

    }else
            $see=$viewstr['lastvisit'];
	$groupname='';
	if($groupid==-1)
		$groupname='';
	else if(!$groupid)
		$groupname='其它';
	else
	{
        //获取groupname
		$query = $_SGLOBAL['db']->query("SELECT main.subject 
		FROM ".tname('bookmark')." main where uid=".$_SGLOBAL['supe_uid']." AND main.type=".$_SC['bookmark_type_dir'].cond_groupid($groupid)."  limit 1");
		if($value =$_SGLOBAL['db']->fetch_array($query))
		$groupname=getstr($value['subject'], 50, 0, 0, 0, 0, -1);
	}
    //获取总条数
    $page=empty($_GET['page'])?0:intval($_GET['page']);
    $perpage=$_SC['bookmark_show_maxnum'];
    $start=$page?(($page-1)*$perpage):0;
    $theurl="space.php?uid=$space[uid]&do=$do&groupid=$groupid";
    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('bookmark')." main where uid=".$_SGLOBAL['supe_uid']." AND main.browserid=".$browserid." AND main.type=".$_SC['bookmark_type_site'].cond_parentid($groupid)),0);
    //获取bookmarklist

	$query = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main
		LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid where uid=".$_SGLOBAL['supe_uid']." AND main.browserid=".$browserid." AND main.type=".$_SC['bookmark_type_site'].cond_parentid($groupid)."  ORDER BY main.".$see." DESC limit ".$start." , ".$_SC['bookmark_show_maxnum']);
	$bookmarklist = array();
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['description'] = getstr($value['description'], 86, 0, 0, 0, 0, -1);
		$value['subject'] = getstr($value['subject'], 50, 0, 0, 0, 0, -1);
		//get the bookmark tag 
		$tag_query= $_SGLOBAL['db']->query("SELECT main.*,field.*  FROM ".tname('linktagbookmark')." main
			LEFT JOIN ".tname('linktag')." field ON main.tagid=field.tagid where main.bmid=".$value['bmid']);
		while($tagvalue=$_SGLOBAL['db']->fetch_array($tag_query)){
			$value['taglist'][$tagvalue['tagid']]=$tagvalue['tagname'];
		}
		$bookmarklist[] = $value;
	}
foreach($bookmarklist as $key => $value) {
	realname_set($value['uid'], $value['username']);
	$bookmarklist[$key] = $value;
}
//分页
$multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);
//图片
$cachefile = S_ROOT.'./data/cache_network_pic.txt';
if(check_network_cache('pic')) {
	$piclist = unserialize(sreadfile($cachefile));
} else {
	$sqlarr = mk_network_sql('pic',
		array('picid', 'uid'),
		array('hot'),
		array('dateline'),
		array('dateline','hot')
	);
	extract($sqlarr);

	//显示数量
	$shownum = 28;
	
	$piclist = array();
	$query = $_SGLOBAL['db']->query("SELECT album.albumname, album.friend, space.username, space.name, space.namestatus, main.* 
		FROM ".tname('pic')." main
		LEFT JOIN ".tname('album')." album ON album.albumid=main.albumid
		LEFT JOIN ".tname('space')." space ON space.uid=main.uid
		WHERE ".implode(' AND ', $wherearr)."
		ORDER BY main.{$order} $sc LIMIT 0,$shownum");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		if(empty($value['friend'])) {
			$value['pic'] = pic_get($value['filepath'], $value['thumb'], $value['remote']);
			$piclist[] = $value;
		}
	}
	if($_SGLOBAL['network']['pic']['cache']) {
		swritefile($cachefile, serialize($piclist));
	}
}
foreach($piclist as $key => $value) {
	realname_set($value['uid'], $value['username'], $value['name'], $value['namestatus']);
	$piclist[$key] = $value;
}


realname_get();

//最后登录名
$membername = empty($_SCOOKIE['loginuser'])?'':sstripslashes($_SCOOKIE['loginuser']);
$wheretime = $_SGLOBAL['timestamp']-3600*24*30;

$_TPL['css'] = 'network';
include_once template("space_bookmark");
//检查缓存
function check_network_cache($type) {
	global $_SGLOBAL;
	
	if($_SGLOBAL['network'][$type]['cache']) {
		$cachefile = S_ROOT.'./data/cache_network_'.$type.'.txt';
		$ftime = filemtime($cachefile);
		if($_SGLOBAL['timestamp'] - $ftime < $_SGLOBAL['network'][$type]['cache']) {
			return true;
		}
	}
	return false;
}

//获得SQL
function mk_network_sql($type, $ids, $crops, $days, $orders) {
	global $_SGLOBAL;
	
	$nt = $_SGLOBAL['network'][$type];
	
	$wherearr = array('1');
	//指定
	foreach ($ids as $value) {
		if($nt[$value]) {
			$wherearr[] = "main.{$value} IN (".$nt[$value].")";
		}
	}
	
	//范围
	foreach ($crops as $value) {
		$value1 = $value.'1';
		$value2 = $value.'2';
		if($nt[$value1]) {
			$wherearr[] = "main.{$value} >= '".$nt[$value1]."'";
		}
		if($nt[$value2]) {
			$wherearr[] = "main.{$value} <= '".$nt[$value2]."'";
		}
	}
	//时间
	foreach ($days as $value) {
		if($nt[$value]) {
			$daytime = $_SGLOBAL['timestamp'] - $nt[$value]*3600*24;
			$wherearr[] = "main.{$value}>='$daytime'";
		}
	}
	//排序
	$order = in_array($nt['order'], $orders)?$nt['order']:array_shift($orders);
	$sc = in_array($nt['sc'], array('desc','asc'))?$nt['sc']:'desc';
	
	return array('wherearr'=>$wherearr, 'order'=>$order, 'sc'=>$sc);
}

?>
