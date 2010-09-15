<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//添加link
function site_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET;
    global $browserid;	
	//操作者角色切换
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//对输入的address description tag进行限制
	$POST['address']= mb_substr(trim($POST['address']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][urllen], 'UTF-8');
	$POST['description']= mb_substr(trim($POST['description']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][deslen], 'UTF-8');
	$POST['tag'] =  mb_substr(trim($POST['tag']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][taglen], 'UTF-8');

	//标题
	$POST['subject'] = getstr(trim($POST['subject']), 0, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');
		
	

	//内容
	if($_SGLOBAL['mobile']) {
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr($POST['description'], 0, 1,1, 1);
	}
	$message = $POST['description'];
	
	//主表
	$linkarr = array(
		'subject' => $POST['subject'],		
	);
	/*
	//没有填写任何东西
	$ckmessage = preg_replace("/(\<div\>|\<\/div\>|\s|\&nbsp\;|\<br\>|\<p\>|\<\/p\>)+/is", '', $message);
	if(empty($ckmessage)) {
		return false;
	}
	*/	
			//增加或修改link
			/*
			olds:
			1:增加link时，为空
			2:修改linkk时，表示该item
			*/
			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 0, 1, 1, 1);	//语词屏蔽
			$sitearr['url']=$POST['address'];
			$sitearr['hashurl']=qhash($sitearr['url']);
			$sitearr['md5url']=md5($sitearr['url']);
			//检查是否已存在,只在增加的时候检查
			if(empty($olds)&&checksiteexisted($sitearr))
			{
				return -1;//link existed
			}

			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 0, 1, 1, 1);	//语词屏蔽
			
			//link 表
		//	$sitearr['postuid'] = $_SGLOBAL['supe_uid'];
			//$sitearr['username'] =$_SGLOBAL['supe_username'];//ramen.sh@gmail.com
		//	$sitearr['username'] = $_SGLOBAL['name'];//城市森林
			$sitearr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$sitearr['link_description'] = $message;
			$sitearr['origin'] = $_SC['link_origin_link'];


            //$sitearr['hashurl']=qhash($sitearr['url']);
			//$sitearr['md5url']=md5($sitearr['url']);

			
			if(empty($olds)){
				//增加一个LINK	
				$sitearr=setlinkimagepath($sitearr);
				$sitearr['verify']=$_SC['link_verify_undo'];
				$sitearr['initaward'] =$sitearr['award']=$_SC['link_award_initial_value'];
				$siteid = inserttable('site', $sitearr, 1);
			}else{
				//修改一个LINK
				$sitearr['url']=  $olds['url'];
				$sitearr['initaward'] =$POST['initaward'];
				$sitearr['award']=calc_link_award($sitearr['initaward'],$olds['storenum'],$olds['viewnum'],$olds['up'],$olds['down']);
				updatetable('site',$sitearr, array('id'=>$olds['siteid']));
				$siteid = $olds['siteid'];
			}
			//tag
			$tagarr=site_tag_batch($siteid,$POST['tag']);
			//update tag
			$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
			$sitearr['tag']=$tag;
			updatetable('site',array('tag'=>$tag), array('id'=>$siteid));

			//cache更新，先获得classid,如果classid为0则无动作
			if(!empty($olds['class']))
			{
				include_once(S_ROOT.'./source/function_cache.php');
				site_cache_3classid($olds['class']);
			}
	//角色切换
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $sitearr;
}
//处理tag
function site_tag_batch($id,$tags)
{
		global $_SGLOBAL;
		$tagarr = array();
		$now_tag = empty($tags)?array():array_unique(explode(' ', $tags));
		
		//if(empty($now_tag)) return $tagarr;
		//获取原来的tags
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('site')." main WHERE main.id=".$id);
		$result = $_SGLOBAL['db']->fetch_array($query);
		if(empty($result))
			return $tagarr;

		 //修正tag显示
		 $old_tags = empty($result['tag'])?array():unserialize($result['tag']);
		
		 $need_delete_tags=array();
		 $need_add_tags=array();
		 $tagarr = $intersect_tag = array_intersect($old_tags,$now_tag);
		//获取old_tag有而现在没有的			
		 $need_delete_tags = array_diff($old_tags,$intersect_tag);
		//清除tag
		if(!empty($need_delete_tags)) {
			  foreach($need_delete_tags as $k=>$v){
				 $_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE id=".$id.' AND tagid='.$k);			
			  }	  
			 $_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode(array_keys($need_delete_tags)).")");
		}
		//获取现在有二old_tag没有的
		 $need_add_tags =   array_diff($now_tag,$intersect_tag);
		 
		 if(empty($need_add_tags))
			 return  $tagarr;
		//记录已存在的tag
		$vtags = array();
		
		$sql = "SELECT tagid, tagname, close FROM ".tname('sitetag')." WHERE tagname IN (".simplode($need_add_tags).")";
		$query = $_SGLOBAL['db']->query($sql);
	
		while ($rt = $_SGLOBAL['db']->fetch_array($query))
		{
			$rt['tagname'] = addslashes($rt['tagname']);
		    $vkey = md5($rt['tagname']);
			$vtags[$vkey] = $rt;
		}

		
		$updatetagids = array();
		foreach ($need_add_tags as $tagname) {
			if(!preg_match('/^([\x7f-\xff_-]|\w){3,20}$/', $tagname)) continue;
			
			$vkey = md5($tagname);
			if(empty($vtags[$vkey])) {
				$setarr = array(
					'tagname' => $tagname,
					'taghash' => qhash($tagname),
					'dateline' => $_SGLOBAL['timestamp'],
					//link的tag进入统计
					'totalnum' => 1
				);
				if ($tagid=inserttable('sitetag', $setarr, 1))
				{
					$tagarr[$tagid] = $tagname;
				}
			} else {
				if(empty($vtags[$vkey]['close'])) {
					$tagid = $vtags[$vkey]['tagid'];
					$updatetagids[] = $tagid;
					$tagarr[$tagid] = $tagname;
				}
			}
		}
		if($updatetagids) 
			$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
		$tagids = array_keys($tagarr);
		$inserts = array();
		foreach ($tagids as $tagid) {
			$inserts[] = "('$tagid','$id')";
		}
		if($inserts) 
			$_SGLOBAL['db']->query("REPLACE INTO ".tname('sitetagsite')." (tagid,siteid) VALUES ".implode(',', $inserts));

		return $tagarr;	
}
//检查site是否已存在
function  checksiteexisted($sitearr)
{
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
		$query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('site')." WHERE hashurl=".$sitearr['hashurl']." AND  md5url='".$sitearr['md5url']."' AND  url='".$sitearr['url']."'");
		if($value=$_SGLOBAL['db']->fetch_array($query))
			return 1;
		return 0;
}

function site_delete_tag($siteid)
{
	global $_SGLOBAL,$_SC;
	//处理tag
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('sitetagsite')." WHERE siteid=".$siteid);
	$updatetagids=array();
	while($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	$_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE siteid=".$siteid);
}
/*
	1:管理员可以删除任何连接，但首先参考收藏数，如果收藏数>0,则不删除
	2:当没有通过验证的站点，则可以删除
*/
function deletesite($siteid){
	//处理link
	global $_SGLOBAL,$_SC;
	$siteitem = getsite($siteid);
	if(empty($siteitem))
		return 0;
	if($siteitem['siteid'])
		return 0;
	if($siteitem['storenum'])//收藏数>0
	{
		updatetable('site',array('delflag'=>1), array('id'=>$siteitem['siteid']));
		return 1;
	}

	$_SGLOBAL['db']->query("DELETE  from ".tname('site')." WHERE id=".$siteid);
	site_delete_tag($siteid);
	//去掉feed
	include_once(S_ROOT.'./source/function_feed.php');
	feed_delete($siteid, 'siteid');
	//重新cache
	include_once(S_ROOT.'./source/function_cache.php');
	site_cache_3classid($siteitem['class']);
	return 1;
}
/*
	如果link的tag没有格式化，则格式化
*/
function convertsitetag($siteid,$tag)
{
		$ntag='';
		if(!empty($tag)&&!preg_match("/^a\:\d+\:{\S+/i",$tag))
		{
			//tag
			$tagarr=site_tag_batch($siteid,$tag);
			//update tag
			$ntag = empty($tagarr)?'':addslashes(serialize($tagarr));
			updatetable('site',array('tag'=>$ntag), array('id'=>$siteid));
			return $ntag;
		}
		return $tag;
}

function siteerr_post($POST, $olds=array())
{
	global $_SGLOBAL, $_SC, $space,$_GET;
	if(empty($olds))
		return 0;
	$linkerr_arr = array(
		'siteid' => $olds['siteid'],
		'uid' => $_SGLOBAL['supe_uid']		
	);
	$linkerr_arr['dateline'] =( empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline']);
	foreach($_SGLOBAL['linkerrtype'] as $key=>$value){
		if(isset($POST['chk1_'.$key]))
		{
			if($key==255)
			{
				$POST['description'] = getstr($POST['description'], 250, 1,1, 1);
				$linkerr_arr['other']=empty($POST['description']);
			}
			else
				$linkerr_arr['errid']=$linkerr_arr['errid'].(empty($linkerr_arr['errid'])?'':',').$key;
		}
	}
	if(empty($linkerr_arr['errid'])&&empty($linkerr_arr['other']))
		return 0;
	//检查是否已经存在
	$linkerr_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkerr')." main WHERE  main.siteid= ".$olds['siteid']);
	$linkerritem=$_SGLOBAL['db']->fetch_array($linkerr_query);
	if(empty($linkerritem))	
		$linkerrid = inserttable('linkerr', $linkerr_arr, 1);
	else
	{
		$err1=explode(",",$linkerr_arr['errid']);
		$err2=explode(",",$linkerritem['errid']);
		$linkerr_arr['errid']=implode(",",array_unique(array_merge($err1,$err2)));
		updatetable('linkerr',$linkerr_arr, array('linkerrid'=>$linkerritem['linkerrid']));
	}
	return 1;
}


function getsitestorenum($siteid)
{
	global $_SGLOBAL;
	$count = 0;
	$count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT storenum FROM ".tname('site')." where id=".$siteid),0);
	echo  $count;
}
?>
