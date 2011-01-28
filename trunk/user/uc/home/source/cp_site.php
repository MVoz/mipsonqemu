<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: cp_blog.php 13026 2009-08-06 02:17:33Z liguode $
*/
if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
//bookmark为"我要收藏"
//get为浏览
$ops=array('checkerror','add','edit','delete','checkseccode','get','relate','bookmark','up','down','view','reporterr','store');
//检查信息
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$siteid= empty($_GET['siteid'])?0:intval(trim($_GET['siteid']));
$item = array();
$relatedlist = array();
if($siteid)
		$item = getsite($siteid);
/*
	permit owner id item 
0--不关心
1--需要符合条件
2--几个中有一个符合即可
*/
$link_priority=array(
 'checkerror'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
// 'manage'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),	
// 'pass'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
// 'reject'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0), 
 'get'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'relate'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'bookmark'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'up'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'down'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'view'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'store'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'reporterr'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1)
);
//权限检查
$ret=check_valid($op,$siteid,$item,$item['postuid'],'managelink',$link_priority);
switch($ret)
{
	case -1:
		showmessage('no_authority_to_do_this');
	break;
	case -2:
		showmessage('error_parameter');
	break;
	default:
	break;
}
include_once(S_ROOT.'./source/function_site.php');
if($op == 'get'){
	include_once(S_ROOT.'./source/every_todayhotcollect.php');
	include_once(S_ROOT.'./source/every_hotdigg.php');
	//得到siteclassname
	$item['classname']=getsiteclassname($item['class']);
	//得到此site的相关site
	$relatesites = getrelatesite($item['class'],$siteid);
	if(sizeof($relatesites)<$_SC['related_site_num'])
	{
		$needadd = $_SC['related_site_num']-sizeof($relatesites);
		for($i=0;$i<$needadd ;$i++){
			$relatesites[]=$todayhotcollect['site'][$i];
		}
	}
	//支取todayhotcollect前8个
	$hotsite = array_slice($relatesites, 0, 8);
/*
	$big_nums = 0;
	foreach($item['relate'] as $key=>$v){
		$item['bigrelate'][$key] = $item['relate'][$key];
		unset($item['relate'][$key]);
		//取出前3个作为big relate
		if((++$big_nums)>=$_SC['related_big_site_num'])
			break;
	}
*/
	//获取hotclass
	//$hotclass = unserialize(sreadfile(S_ROOT.'./data/todayhotclass.txt'));
	//$hottag = unserialize(sreadfile(S_ROOT.'./data/todayhottag.txt'));
}
elseif($op == 'edit'){
		//处理edit提交
		if(submitcheck('editsubmit')) {
			$item = site_post($_POST, $item);
			if(is_array($item)) {
				showmessage('do_success',$_SGLOBAL['refer']);
			} elseif($item) {
				showmessage('do_error');
			}
		}
}
elseif($op == 'relate'){
		$relatedlist[]=$item;		
}
elseif($_GET['op'] == 'delete') {
	//删除
	if(submitcheck('deletesubmit')) {
		if(deletelink($siteid)) {
			$url =$_SGLOBAL['refer'];
			showmessage('do_success', $url, 0);
		} else {
			showmessage('failed_to_delete_operation');
		}
	}	
}elseif($_GET['op'] == 'checkseccode'){
	//验证码
		if(ckseccode(trim($_GET['seccode']))) {
			showmessage('succeed');
		} else {
			showmessage('incorrect_code');
		}
}elseif($_GET['op']=='up'){
		if(updatestatistic('site','up',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid'])))
			showmessage($item['up']+1);
		else{
			$errstr=$item['up'];
			include_once template("message");
			return;
		}

}elseif($_GET['op']=='down'){
        if(updatestatistic('site','down',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid'])))
			showmessage($item['down']+1);
		else{
			$errstr=$item['down'];
			include_once template("message");
			return;
		}

}elseif($_GET['op']=='view'){
        updatestatistic('site','viewnum',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid']));
		showmessage($item['viewnum']+1);
}elseif($_GET['op']=='store'){
	  updatesitestorenum($item['siteid'],1);
	  exit();
}elseif($_GET['op']=='reporterr'){
		//举报错误
		  include_once(S_ROOT.'./data/data_siteerrtype.php');
		  if(submitcheck('errsubmit')) {
			//验证码
			if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
				showmessage('incorrect_code');
			}
			$ret = siteerr_post($_POST, $item);
			if($ret) {	
				showmessage('do_success',$_SGLOBAL[refer]);
			} else{
				showmessage('that_should_at_least_write_things');
			}
		}
}elseif($_GET['op']=='checkerror'){

		$orderarr=$orderarr." ORDER by main.dateline DESC ";
		$theurl="cp.php?ac=$ac&op=$op";
		//分页获取总条数
		$page=empty($_GET['page'])?0:intval($_GET['page']);
		$perpage=$_SC['bookmark_show_maxnum'];
		$start=$page?(($page-1)*$perpage):0;
		
		//获取总数
		 $count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('linkerr')),0);

		//获取所有没有通过验证的书签提交
		$query  = $_SGLOBAL['db']->query("SELECT * FROM ".tname('linkerr')." main left join ".tname("link")." field on main.siteid=field.siteid ".$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);
		while($value =$_SGLOBAL['db']->fetch_array($query)){
			$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
			$err=explode(",",$value['errid']);
			$value['errid']='';
			foreach($err as $key=>$val)
			{
			   $value['errid']=$value['errid'].'   '.$key.':'.$_SGLOBAL['linkerrtype'][$val];
			}
			$value['errid']=$value['errid'].$value['other'];
			$linklist[]=$value;
			$value_err['link_description']=$value['errid'];
			$linklist[]= $value_err;
		}
		//分页
		$link_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

		$_TPL['css'] = 'network'; 


}elseif($_GET['op']=='bookmark'){
/*
	if(submitcheck('bookmarksubmit')) {
	}
*/
	$browserid=gethttpbrowserid(); 
}else {
	 if(submitcheck('addsubmit')) {
		 //收录站点
		if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
			showmessage('incorrect_code');
		}
		include_once(S_ROOT.'./source/function_site.php');
		$item = announce_post($_POST);
		exit();
	}
	//添加编辑
	//将从上榜获得的tag中的,去掉
	/*
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//获取常用的tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	*/
}

include_once template("cp_site");

?>
