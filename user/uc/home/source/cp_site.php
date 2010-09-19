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
$ops=array('checkerror','manage','add','edit','delete','pass','reject','checkseccode','get','relate','bookmark','updatesiteupnum','updatesitedownnum','updatesiteviewnum','reporterr','toolbar');
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
 'manage'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0),
 'add'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0),
 'edit'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),
 'delete'=>array('permit'=>2,'owner'=>2,'id'=>1,'item'=>1),	
 'pass'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'reject'=>array('permit'=>1,'owner'=>0,'id'=>1,'item'=>1),
 'checkseccode'=>array('permit'=>0,'owner'=>0,'id'=>0,'item'=>0), 
 'get'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'relate'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'bookmark'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'updatesiteupnum'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'updatesitedownnum'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'updatesiteviewnum'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'reporterr'=>array('permit'=>0,'owner'=>0,'id'=>1,'item'=>1),
 'toolbar'=>array('permit'=>1,'owner'=>0,'id'=>0,'item'=>0)
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
	//得到siteclassname
	$item['classname']=getsiteclassname($item['class']);
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
		//正确显示tag，array-->string
		$item['tag'] =implode(" ",$item['tag']); 
}
elseif($op == 'relate'){
		//正确显示tag
		$item['link_tag'] = empty($item['link_tag'])?array():unserialize($item['link_tag']);
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
}elseif($_GET['op']=='updatesiteupnum'){
		//更新顶数
		updatestatistic('site','up',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid']));
		showmessage($item['up']+1);

}elseif($_GET['op']=='updatesitedownnum'){
		//更新顶数
        updatestatistic('site','down',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid']));
		showmessage($item['down']+1);

}elseif($_GET['op']=='updatesiteviewnum'){
		//更新顶数
        updatestatistic('site','viewnum',array('updateid'=>$item['siteid'],'feedid'=>$item['siteid']));
		showmessage($item['viewnum']+1);
}elseif($_GET['op']=='reporterr'){
		//举报错误
		  include_once(S_ROOT.'./data/data_linkerrtype.php');
		  if(submitcheck('errsubmit')) {
			//验证码
			if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
				showmessage('incorrect_code');
			}
			$ret = linkerr_post($_POST, $item);
			if($ret) {	
				showmessage('do_success',$_SGLOBAL[refer]);
			} else{
				showmessage('that_should_at_least_write_things');
			}
		}
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


}elseif($_GET['op']=='pass'){
	if(submitcheck('passsubmit')) {
		include_once(S_ROOT.'./source/function_link.php');
		link_pass($item);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}

}elseif($_GET['op']=='bookmark'){

	if(submitcheck('bookmarksubmit')) {
	}
	$browserid=(empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:intval($_GET['browserid']);
	//正确显示tag
	//$item['link_tag'] = implode(' ',empty($item['link_tag'])?array():unserialize($item['link_tag']));
	//获取常用的tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
}elseif($_GET['op']=='toolbar'){
	  if(submitcheck('addsubmit')) {
		linktoolbar_post($_POST);
		showmessage('do_success', $_SGLOBAL['refer'], 0);
	}
}else {
	 if(submitcheck('addsubmit')) {
		//验证码
		if(checkperm('seccode') && !ckseccode($_POST['seccode'])) {
			showmessage('incorrect_code');
		}
		$item = link_post($_POST, $item);
		if(is_array($item)) {
			//$url = $_SGLOBAL['refer'];		
			showmessage('do_success');
		} elseif($item==false) {
			showmessage('that_should_at_least_write_things');
		}elseif($item==-1) {
			showmessage('link_has_existed');
		}
	}
	//添加编辑
	//将从上榜获得的tag中的,去掉
	$_GET['tag']=(empty($_GET['tag']))?'':str_replace(array(','), array(' '), $_GET['tag']);

	//获取常用的tag
	$shownums=$_SC['favorite_tag_maxnum'];
	$tag_query  = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('sitetag')." main ORDER BY main.totalnum DESC limit 0,".$shownums);
	while($value =$_SGLOBAL['db']->fetch_array($tag_query))
		$taglist[$value['tagid']]=$value['tagname'];
	/*
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
	*/
}

include_once template("cp_site");

?>
