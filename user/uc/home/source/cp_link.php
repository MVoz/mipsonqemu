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
$ops=array('manage','add','edit','delete','pass','reject','checkseccode','get','relate','bookmark');
//检查信息
$op = (empty($_GET['op']) || !in_array($_GET['op'], $ops))?'add':$_GET['op'];
$linkid= empty($_GET['linkid'])?0:intval(trim($_GET['linkid']));
$linkitem = array();
$relatedlist = array();
if($linkid)
{
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main where main.linkid=".$linkid);
	$linkitem = $_SGLOBAL['db']->fetch_array($query);
	//正确显示tag
	$linkitem['link_tag'] = implode(' ',empty($linkitem['link_tag'])?array():unserialize($linkitem['link_tag']));
}
/*
	permit owner id item 
0--不关心
1--需要符合条件
2--几个中有一个符合即可
*/
$link_priority=array(
 'manage'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),	
 'pass'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'reject'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0), 
 'get'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'relate'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'bookmark'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1)
);
$ret=check_valid($op,$linkid,$linkitem,$linkitem['postuid'],'managelink',$link_priority);
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
//权限检查
if(empty($linkitem)) {
	//实名认证
	ckrealname('blog');
	
	//视频认证
	ckvideophoto('blog');
	
	//新用户见习
	cknewuser();
	
	//判断是否发布太快
	$waittime = interval_check('post');
	if($waittime > 0) {
		showmessage('operating_too_fast','',1,array($waittime));
	}
	
	//接收外部标题
//blog['subject'] = empty($_GET['subject'])?'':getstr($_GET['subject'], 80, 1, 0);
//blog['message'] = empty($_GET['message'])?'':getstr($_GET['message'], 5000, 1, 0);
	
} 

 if(submitcheck('addsubmit')) {
	//验证码
	if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
		showmessage('incorrect_code');
	}
	include_once(S_ROOT.'./source/function_link.php');
	$linkitem = link_post($_POST, $linkitem);
	if(is_array($linkitem)) {
		//$url = $_SGLOBAL['refer'];		
		showmessage('do_success');
	} elseif($linkitem==false) {
		showmessage('that_should_at_least_write_things');
	}elseif($linkitem==-1) {
		showmessage('link_has_existed');
	}
}
if($op == 'get'){

}
elseif($op == 'relate'){
		$relatedlist[]=$linkitem;
}
elseif($_GET['op'] == 'delete') {
	//删除
	if(submitcheck('deletesubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		if(deletelink($linkid)) {
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
}
elseif($_GET['op'] == 'edithot') {
	//权限
	if(!checkperm('manageblog')) {
		showmessage('no_privilege');
	}
	
	if(submitcheck('hotsubmit')) {
		$_POST['hot'] = intval($_POST['hot']);
		updatetable('blog', array('hot'=>$_POST['hot']), array('blogid'=>$blog['blogid']));
		if($_POST['hot']>0) {
			include_once(S_ROOT.'./source/function_feed.php');
			feed_publish($blog['blogid'], 'blogid');
		} else {
			updatetable('feed', array('hot'=>$_POST['hot']), array('id'=>$blog['blogid'], 'idtype'=>'blogid'));
		}
		
		showmessage('do_success', "space.php?uid=$blog[uid]&do=blog&id=$blog[blogid]", 0);
	}
	
}elseif($_GET['op']=='updatevisitstat'){
		include_once(S_ROOT.'./source/function_bookmark.php');
        updatevisitstat($_GET['bmid']);

}elseif($_GET['op']=='manage'){

		$wherearr='';
		$orderarr='';
		$theurl='';
		$wherearr=$wherearr." where main.origin=".$_SC['link_origin_link'];
		$wherearr=$wherearr." AND main.verify=".$_SC['link_verify_undo'];

		$orderarr=$orderarr." ORDER by main.link_dateline DESC ";

		$theurl="cp.php?ac=$ac&op=$op";
		//分页获取总条数
		$page=empty($_GET['page'])?0:intval($_GET['page']);
		$perpage=$_SC['bookmark_show_maxnum'];
		$start=$page?(($page-1)*$perpage):0;
		
		//获取总数
		 $count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('link')." main ".$wherearr),0);

		//获取所有没有通过验证的书签提交
		$query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main ".$wherearr.$orderarr." limit ".$start." , ".$_SC['bookmark_show_maxnum']);

		while($value =$_SGLOBAL['db']->fetch_array($query)){
			$value['link_tag'] = implode(' ',empty($value['link_tag'])?array():unserialize($value['link_tag']));
			$linklist[]=$value;
		}
		//分页
		$link_multi = multi($count, $perpage, $page, $theurl,'bmcontent','bmcontent',1);

		$_TPL['css'] = 'network';
}elseif($_GET['op']=='pass'){
	if(submitcheck('passsubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		link_pass($linkitem);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}

}elseif($_GET['op']=='bookmark'){
	if(submitcheck('bookmarksubmit')) {
	}
	$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$browsertype))?$browsertype['ie']:intval($_GET['browserid']);
	//正确显示tag
	//$linkitem['link_tag'] = implode(' ',empty($linkitem['link_tag'])?array():unserialize($linkitem['link_tag']));
	//获取常用的tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linktag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
} else {
	//添加编辑
	//将从上榜获得的tag中的,去掉
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//获取常用的tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linktag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	//获取class分类
	$class_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=0");
	while($value =$_SGLOBAL['db']->fetch_array($class_query))
	{
		//获取二级目录
		$classnd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$value['groupid']);
		while($classnd_value =$_SGLOBAL['db']->fetch_array($classnd_query))
		{
			//获取三级目录
			$classrd_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('linkclass')." main WHERE main.parentid=".$classnd_value['groupid']);
			while($classrd_value =$_SGLOBAL['db']->fetch_array($classrd_query))
			{
				$classnd_value['grandson'][]= $classrd_value;
			}
			$value['son'][]=$classnd_value;
		}
		$classlist[]=$value;
	}
}

include_once template("cp_link");

?>
