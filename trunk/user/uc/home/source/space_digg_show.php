<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: network_album.php 12078 2009-05-04 08:28:37Z zhengqingpeng $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$theurl="diggpage";
$digglist = array();

//修正一下page ，0不变，其它情况减1
$nowpage=($page)?($page-1):0;
$start=$page?(($page-1)*$perpage):0;
$count = 0;
if($uid){
	$fileprefix='./data/diggcache/digg_user_'.$userid.'_';
	$theurl = $theurl.'&uid='.$uid;
}else{
	$fileprefix='./data/diggcache/digg_';
}
if(!check_cachelock('digg')) {
	//没有lock,则可以读取
	if(!file_exists(S_ROOT.$fileprefix.'count.txt')){
		include_once(S_ROOT.'./source/function_cache.php');
		if($uid)
			digg_cache(0,0,$uid,0);
		else
			digg_cacheall();
	}
	$count = sreadfile(S_ROOT.$fileprefix.'count.txt');
	$maxdiggid=sreadfile(S_ROOT.$fileprefix.'maxdiggid.txt');
	$maxpage = floor($maxdiggid/($_SC['digg_show_maxnum']/2));

	$i = $maxpage;
	$diggcount = 0;
	//find the start page 
	while($i>=0){
		$diggcount+=sreadfile(S_ROOT.$fileprefix.'page_'.$i.'_count.txt');		
		if($diggcount>=$start)
			break;
		$i--;
	}
	$left = $perpage;
	if($diggcount>$start){
			$digglist=unserialize(sreadfile(S_ROOT.$fileprefix.'page_'.($i).'.txt'));
			$digglist=array_slice($digglist,$start-$diggcount,$diggcount-$start);
			$left =  $left-($diggcount-$start);
	}
 	while($left&&((--$i)>=0)){
		   $digglist_part=array();
		   $digglist_part=unserialize(sreadfile(S_ROOT.$fileprefix.'page_'.($i).'.txt'));
		   $sizeofdigglist_part=sizeof($digglist_part);
		   if($sizeofdigglist_part>$left){
			   $digglist_part=array_slice($digglist_part,0,$left);
			   $digglist=array_merge($digglist,$digglist_part);
			   $left= $left-$left;
		   }else{
				$digglist=array_merge($digglist,$digglist_part);
				$left= $left-$sizeofdigglist_part;
		   }
	}

} else {
	$wherearr='';
	if(!empty($uid))
		 $wherearr=' where main.postuid='.$uid;

    $count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('digg')),0);
	$query = $_SGLOBAL['db']->query("SELECT main.*	FROM ".tname('digg')." main ".$wherearr." ORDER BY main.dateline DESC LIMIT $start,$shownum");

	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['subject'] = getstr($value['subject'], 50);
		$value['cutsubject'] = getstr(trim($value['subject']), 28);
		$digglist[] = $value;
	}
	if($_SGLOBAL['network']['digg']['cache']) {

	}
}
foreach($digglist as $key => $value) {
	$value['tag'] = empty($value['tag'])?array():unserialize($value['tag']);
	include_once(S_ROOT.'./source/function_digg.php');
	$value['viewnum'] = getdiggnumparameter($value['diggid'],'viewnum');
	$digglist[$key] = $value;
}
//分页
$diggmulti = multi($count, $perpage, $page, $theurl,'diggcontent','diggcontent',1);
?>
