<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//添加link
function link_post($POST, $olds=array()) {
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
		'link_subject' => $POST['subject'],		
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
			$linkarr['url']=$POST['address'];
			$linkarr['hashurl']=qhash($linkarr['url']);
			$linkarr['md5url']=md5($linkarr['url']);
			//检查是否已存在,只在增加的时候检查
			if(empty($olds)&&checklinkexisted($linkarr))
			{
				return -1;//link existed
			}

			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 0, 1, 1, 1);	//语词屏蔽
			
			//link 表
			$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
			//$linkarr['username'] =$_SGLOBAL['supe_username'];//ramen.sh@gmail.com
			$linkarr['username'] = $_SGLOBAL['name'];//城市森林
			$linkarr['link_dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$linkarr['link_description'] = $message;
			//如果olds不为空，则是编辑状态，otherwise，为增加
			$linkarr['origin'] =(empty($olds))?$_SC['link_origin_link']:$olds['origin'];


            //$linkarr['hashurl']=qhash($linkarr['url']);
			//$linkarr['md5url']=md5($linkarr['url']);
			$linkarr=setlinkimagepath($linkarr);
			$linkarr['verify']=$_SC['link_verify_undo'];
			
			if(empty($olds)){
				//增加一个LINK	
				$linkarr['initaward'] =$linkarr['award']=$_SC['link_award_initial_value'];
				$linkid = inserttable('link', $linkarr, 1);
			}else{
				//修改一个LINK
				$linkarr['url']=  $olds['url'];
				$linkarr['initaward'] =$POST['initaward'];
				$linkarr['award']=calc_link_award($linkarr['initaward'],$olds['storenum'],$olds['viewnum'],$olds['up'],$olds['down']);
				updatetable('link',$linkarr, array('linkid'=>$olds['linkid']));
				$linkid = $olds['linkid'];
			}
			//tag
			$tagarr=link_tag_batch($linkid,$POST['tag']);
			//update tag
			$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
			$linkarr['link_tag']=$tag;
			updatetable('link',array('link_tag'=>$tag), array('linkid'=>$linkid));

			//cache更新，先获得classid,如果classid为0则无动作
			if(!empty($olds[classid]))
			{
				include_once(S_ROOT.'./source/function_cache.php');
				link_cache_classid($olds[classid]);
			}
	//角色切换
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $linkarr;
}
//处理tag
function link_tag_batch($id,$tags)
{
		global $_SGLOBAL;
		$tagarr = array();
		$now_tag = empty($tags)?array():array_unique(explode(' ', $tags));
		
		//if(empty($now_tag)) return $tagarr;
		//获取原来的tags
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main WHERE main.linkid=".$id);
		$result = $_SGLOBAL['db']->fetch_array($query);
		if(empty($result))
			return $tagarr;
		//如果已在site表中，则不处理
		if($result['siteid'])
			{
				//返回现有的
				return empty($result['tag'])?array():unserialize($result['tag']);
			}
		//修正tag显示
		 if(!empty($result['tag'])&&!preg_match("/^a\:\d+\:{\S+/i",$result['tag']))
		{
			 //如果原先是正常的tag字符串，则认为空
			 $old_tags =array();
		}else//修正tag显示		 
			 $old_tags = empty($result['tag'])?array():unserialize($result['tag']);
		
		 $need_delete_tags=array();
		 $need_add_tags=array();
		 $tagarr = $intersect_tag = array_intersect($old_tags,$now_tag);
		//获取old_tag有而现在没有的			
		 $need_delete_tags = array_diff($old_tags,$intersect_tag);
		//清除tag
		if(!empty($need_delete_tags)) {
			  foreach($need_delete_tags as $k=>$v){
				 $_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE linkid=".$id.' AND tagid='.$k);			
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
					'sitetotalnum' => 0,
					'linktotalnum' => 1
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
			$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET linktotalnum=linktotalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
		$tagids = array_keys($tagarr);
		$inserts = array();
		foreach ($tagids as $tagid) {
			$inserts[] = "('$tagid','$id')";
		}
		if($inserts) 
			$_SGLOBAL['db']->query("REPLACE INTO ".tname('sitetagsite')." (tagid,linkid) VALUES ".implode(',', $inserts));

		return $tagarr;	
}
/*
function link_tag_batch($linkid, $tags) {
	global $_SGLOBAL;

	$tagarr = array();
	$tagnames = empty($tags)?array():array_unique(explode(' ', $tags));
	if(empty($tagnames)) return $tagarr;

	$vtags = array();
	$query = $_SGLOBAL['db']->query("SELECT tagid, tagname, close FROM ".tname('linktag')." WHERE tagname IN (".simplode($tagnames).")");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		$value['tagname'] = addslashes($value['tagname']);
		$vkey = md5($value['tagname']);
		$vtags[$vkey] = $value;
	}
	$updatetagids = array();
	foreach ($tagnames as $tagname) {
		if(!preg_match('/^([\x7f-\xff_-]|\w){3,20}$/', $tagname)) continue;
		
		$vkey = md5($tagname);
		if(empty($vtags[$vkey])) {
			$setarr = array(
				'tagname' => $tagname,
				'uid' => $_SGLOBAL['supe_uid'],
				'dateline' => $_SGLOBAL['timestamp'],
				'totalnum' => 1
			);
			$tagid = inserttable('linktag', $setarr, 1);
			$tagarr[$tagid] = $tagname;
		} else {
			if(empty($vtags[$vkey]['close'])) {
				$tagid = $vtags[$vkey]['tagid'];
				$updatetagids[] = $tagid;
				$tagarr[$tagid] = $tagname;
			}
		}
	}
	if($updatetagids) $_SGLOBAL['db']->query("UPDATE ".tname('linktag')." SET totalnum=totalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
	$tagids = array_keys($tagarr);
	$inserts = array();
	foreach ($tagids as $tagid) {
		$inserts[] = "('$tagid','$linkid')";
	}
	if($inserts) $_SGLOBAL['db']->query("REPLACE INTO ".tname('linktaglink')." (tagid,linkid) VALUES ".implode(',', $inserts));

	return $tagarr;
}
*/
//检查link是否已存在
function  checklinkexisted($linkarr)
{
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
		$query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." WHERE hashurl=".$linkarr['hashurl']." AND  md5url='".$linkarr['md5url']."' AND  url='".$linkarr['url']."' limit 1");
		if($value=$_SGLOBAL['db']->fetch_array($query))
			return 1;
//同时需要检查site表中是否已经含有此站点
		$query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('site')." WHERE hashurl=".$linkarr['hashurl']." AND  md5url='".$linkarr['md5url']."' AND  url='".$linkarr['url']."' limit 1");
		if($value=$_SGLOBAL['db']->fetch_array($query))
			return 1;
		return 0;
}

function link_delete_tag($linkid)
{
	global $_SGLOBAL,$_SC;
	//处理tag
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('sitetagsite')." WHERE linkid=".$linkid);
	$updatetagids=array();
	while($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	$_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE linkid=".$linkid);
}
/*
	1:管理员可以删除任何连接，但首先参考收藏数，如果收藏数>0,则不删除
	2:当没有通过验证的站点，则可以删除
*/
function deletelink($linkid){
	//处理link
	global $_SGLOBAL,$_SC;
	$link_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." main WHERE  main.linkid= ".$linkid);
	$linkitem=$_SGLOBAL['db']->fetch_array($link_query);
	if(empty($linkitem))
		return 0;
	if($linkitem['siteid'])
		return 0;
	if($linkitem['storenum'])//收藏数>0
	{
		updatetable('link',array('delflag'=>1), array('linkid'=>$linkitem['linkid']));
		return 1;
	}
	$isself=0;
	if($linkitem['postuid']==$_SGLOBAL['supe_uid'])
		$isself=1;
	switch($linkitem['verfify'])
	{
		case $_SC['link_verify_undo']:
				 $_SGLOBAL['db']->query("DELETE  from ".tname('link')." WHERE linkid=".$linkid);
				link_delete_tag($linkid);
		break;
		case $_SC['link_verify_passed']:
				if($isself)
					updatetable('link',array('postuid'=>$_SC['link_delete_uid']), array('linkid'=>$linkid));
		break;
		case $_SC['link_verify_failed']:
				 $_SGLOBAL['db']->query("DELETE  from ".tname('link')." WHERE linkid=".$linkid);
				link_delete_tag($linkid);
		break;
	}
	//去掉feed
	include_once(S_ROOT.'./source/function_feed.php');
	feed_delete($linkid, 'linkid');
	return 1;
}
function link_pass($link)
{
	global $_SGLOBAL,$_SC;
	$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET verify=".$_SC['link_verify_passed']." WHERE linkid=".$link['linkid']);
}
/*
	如果link的tag没有格式化，则格式化
*/
function convertlinktag($linkid,$tag)
{
		$ntag='';
		if(!empty($tag)&&!preg_match("/^a\:\d+\:{\S+/i",$tag))
		{
			//tag
			$tagarr=link_tag_batch($linkid,$tag);
			//update tag
			$ntag = empty($tagarr)?'':(serialize($tagarr));
			updatetable('link',array('link_tag'=>addslashes($ntag)), array('linkid'=>$linkid));
			return $ntag;
		}
		return $tag;
}

function linkerr_post($POST, $olds=array())
{
	global $_SGLOBAL, $_SC, $space,$_GET;
	if(empty($olds))
		return 0;
	$linkerr_arr = array(
		'linkid' => $olds['linkid'],
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
	$linkerr_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('linkerr')." main WHERE  main.linkid= ".$olds['linkid']);
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
function linktoolbar_post($POST)
{
	global $_SGLOBAL, $_SC, $space,$_GET;
    global $browserid;	

	//标题
	$POST['subject'] = getstr(trim($POST['subject']), 80, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');	
	 
	//内容 
	$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
		
	//主表
	$linktoolbar_arr = array(
		'subject' => $POST['subject'],		
	);
	$POST['address'] = shtmlspecialchars(trim($POST['address']));
	$POST['address'] = getstr($POST['address'], 1024, 1, 1, 1);	//语词屏蔽
	$linktoolbar_arr['url']=$POST['address'];
	$linktoolbar_arr['hashurl']=qhash($linktoolbar_arr['url']);
	$linktoolbar_arr['postuid']=$_SGLOBAL['supe_uid'];
	$linktoolbar_arr['classid']=$POST['category'];
	$linktoolbar_arr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
	$count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('linktoolbar')." where hashurl=".$linktoolbar_arr['hashurl']." and url='".$linktoolbar_arr['url']."'"),0);

	

	if(empty($count)){
				//增加一个LINK				
				$linkid = inserttable('linktoolbar', $linktoolbar_arr, 1);
	}else{
				
	}
	return 1;
}

function getLinkStorenum($linkid)
{
	global $_SGLOBAL;
	$count = 0;
	if($siteid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT storenum FROM ".tname('link')." where linkid=".$linkid),0))
	{
		$count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT storenum FROM ".tname('site')." where id=".$siteid),0);
	}else	
		$count=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT storenum FROM ".tname('link')." where linkid=".$linkid),0);
	echo  $count;
}
function announce_post($_POST)
{
		global $_SGLOBAL;
		$refer =  $_SGLOBAL['refer'];
		unset($_POST['refer']);
		unset($_POST['addsubmit']);
		unset($_POST['formhash']);
		unset($_POST['seccode']);
		
		//对输入的address description tag进行限制
		$_POST['siteurl']= mb_substr(trim($_POST['siteurl']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][urllen], 'UTF-8');
		$_POST['jianjie']= mb_substr(trim($_POST['jianjie']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][deslen], 'UTF-8');
		$_POST['tag'] =  mb_substr(trim($_POST['tag']), 0, $_SGLOBAL['browser'][$_SGLOBAL['browsertype']['ie']][taglen], 'UTF-8');

		//标题
		$_POST['name']  = getstr(trim($_POST['name']), 0, 1, 1, 1);

        if (empty($_POST['name']))
        {
			showmessage('site_name_cannot_empty', $refer, 10);
        }

        if (empty($_POST['siteurl']))
        {
			showmessage('site_url_cannot_empty', $refer, 10);
        }
        $tmp = parse_url($_POST['siteurl']);
        $domain = $tmp['host'];
        if (!eregi("^http[s]?://", $_POST['siteurl']) || empty($domain))
        {
			showmessage('网站网址不正确', $refer, 10);
        }
        $domain = addslashes($domain);

        $_POST['jianjie'] = (empty($_POST['jianjie'])) ? '' : getstr(trim($_POST['jianjie']), 200, 1, 1, 1);
        if (empty($_POST['jianjie']))
        {
			showmessage('网站简介不能为空', $refer, 10);
        }

		//$tags = empty($_POST['tag'])?array():array_unique(explode(' ', $_POST['tag'])

        $_POST['pv'] = (empty($_POST['pv'])) ? '' : getstr(trim($_POST['pv']), 12, 1, 1, 1);
        $_POST['class'] = (empty($_POST['class'])) ? '' :getstr(trim($_POST['class']), 128, 1, 1, 1);
        if (empty($_POST['class']))
        {
			showmessage('网站分类不能为空', $refer, 10);
        }

        $_POST['icp'] = (empty($_POST['icp'])) ? '' : getstr(trim($_POST['icp']), 32, 1, 1, 1);
        $_POST['sitetime'] = (empty($_POST['sitetime'])) ? '' : getstr(trim($_POST['sitetime']), 32, 1, 1, 1);
        $_POST['lianxiren'] = (empty($_POST['lianxiren'])) ? '' : getstr(trim($_POST['lianxiren']), 32, 1, 1, 1);
        $_POST['address'] = (empty($_POST['address'])) ? '' : getstr(trim($_POST['address']), 128, 1, 1, 1);


        $_POST['mobile'] = (empty($_POST['mobile'])) ? '' :getstr(trim($_POST['mobile']), 32, 1, 1, 1);
        $_POST['tel'] = (empty($_POST['tel'])) ? '' : getstr(trim($_POST['tel']), 32, 1, 1, 1);
        $_POST['email'] = (empty($_POST['email'])) ? '' : getstr(trim($_POST['email']), 64, 1, 1, 1);
        if (empty($_POST['email']))
        {
			showmessage('电子邮箱不能为空', $refer, 10);
        }

        $_POST['sharelink'] = (empty($_POST['sharelink'])) ? '' : strip($_POST['sharelink']);

		$q = $_SGLOBAL['db']->query("SELECT * FROM ".tname('urladd')." where domain='".$domain."' LIMIT 1");
		$rs = $_SGLOBAL['db']->fetch_array($q);

        if (!empty($rs))
        {
            if ($rs['type'] == 0)
            {
			   	showmessage('该站点已提交,请耐心等待工作人员的审核,不要重复提交!', $refer, 10);
            }
            elseif ($rs['type'] == 1)
            {
			   	showmessage('该站点已提交并且通过审核,已收录该站点!', $refer, 10);
            }
            else
            {
				showmessage('该站点上次提交未通过审核,请不要重复提交! 如有疑问请联系');
            }
        }

        $info = $_POST;
        foreach($info as &$v)
        {
            $v = htmlentities($v, ENT_NOQUOTES, 'utf-8');
        }
        $infos = addslashes(serialize($info));

       // app_db::insert('ylmf_urladd', array('domain', 'info', 'addtime'), array($domain, $infos, time()));
		$_SGLOBAL['db']->query("INSERT INTO ".tname('urladd')." (domain,postuid,username, info, addtime) VALUES('".$domain."','".$_SGLOBAL['supe_uid']."','".$_SGLOBAL['name']."','".$infos."','".time()."')");

		showmessage('站点信息已成功提交,请耐心等待工作人员的审核!', $refer, 10);  
}
?>
