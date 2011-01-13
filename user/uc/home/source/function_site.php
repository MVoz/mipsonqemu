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
		 if(!empty($result['tag'])&&!preg_match("/^a\:\d+\:{\S+/i",$result['tag']))
		{
			 //如果原先是正常的tag字符串，则认为空
			 $old_tags =array();
		}else
		     $old_tags = empty($result['tag'])?array():unserialize($result['tag']);
		
		 $need_delete_tags=array();
		 $need_add_tags=array();
		 $intersect_tag=array();
		 $tagarr=$intersect_tag = array_intersect($old_tags,$now_tag);
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
		 $need_add_tags = array_diff($now_tag,$intersect_tag);

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
					//site的tag进入统计
					'sitetotalnum' => 1,
					'linktotalnum' => 0
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
			$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET sitetotalnum=sitetotalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
		$tagids = array_keys($tagarr);
		$inserts = array();
		foreach ($tagids as $tagid) {
			$inserts[] = "('$tagid','$id')";
		}
		if($inserts) 
			$_SGLOBAL['db']->query("REPLACE INTO ".tname('sitetagsite')." (tagid,siteid) VALUES ".implode(',', $inserts));

		return $tagarr;	
}
//update site的保存数目
//$type---0--减少 1--add
function updatesitestorenum($siteid,$type)
{
	 global $_SGLOBAL,$_SC;
     if(!$_SGLOBAL['supe_uid'])
            return;
	 if($type)
	 {
			$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET storenum=storenum+1 WHERE id=".$siteid);
			$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET todaystorenum=todaystorenum+1 WHERE id=".$siteid);
	 }else{
			$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET storenum=storenum-1 WHERE id=".$siteid);
			$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET todaystorenum=todaystorenum-1 WHERE id=".$siteid);
	 }
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
			$ntag = empty($tagarr)?'':(serialize($tagarr));
			updatetable('site',array('tag'=>addslashes($ntag)), array('id'=>$siteid));
			return $ntag;
		}
		return $tag;
}

function siteerr_post($POST, $olds=array())
{
	global $_SGLOBAL, $_SC, $space,$_GET;
	if(empty($olds))
		return 0;
	$siteerr_arr = array(
		'siteid' => $olds['siteid'],
		'uid' => $_SGLOBAL['supe_uid']		
	);
	$siteerr_arr['dateline'] =( empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline']);
	foreach($_SGLOBAL['siteerrtype'] as $key=>$value){
		if(isset($POST['chk1_'.$key]))
		{
			if($key==255)
			{
				$POST['description'] = getstr($POST['description'], 250, 1,1, 1);
				$siteerr_arr['other']=empty($POST['description']);
			}
			else
				$siteerr_arr['errid']=$siteerr_arr['errid'].(empty($siteerr_arr['errid'])?'':',').$key;
		}
	}
	if(empty($siteerr_arr['errid'])&&empty($siteerr_arr['other']))
		return 0;
	//检查是否已经存在
	$siteerr_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('siteerr')." main WHERE  main.siteid= ".$olds['siteid']);
	$siteerritem=$_SGLOBAL['db']->fetch_array($siteerr_query);
	if(empty($siteerritem))	
		$siteerrid = inserttable('siteerr', $siteerr_arr, 1);
	else
	{
		$err1=explode(",",$siteerr_arr['errid']);
		$err2=explode(",",$siteerritem['errid']);
		$siteerr_arr['errid']=implode(",",array_unique(array_merge($err1,$err2)));
		updatetable('siteerr',$siteerr_arr, array('siteerrid'=>$siteerritem['siteerrid']));
	}
	return 1;
}


function getsitestorenum($siteid)
{
	$count = 0;
	$wherearr = array(
			'id'=>$siteid
	);
	$count = getcount('site',$wherearr,'storenum');
	echo  $count;
}
function getsiteviewnum($siteid)
{
	$count = 0;
	$wherearr = array(
			'id'=>$siteid
	);
	$count = getcount('site',$wherearr,'viewnum');
	echo  $count;
}
//siteid为排除在外
function getrelatesite($classid,$siteid)
{
	global $_SGLOBAL,$_SC;
	$ret = array();
	$isSecClass = 0; 
	$isThirdClass = 0;
	$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('siteclass')." main where main.classid=".$classid);
	$classitem = $_SGLOBAL['db']->fetch_array($query);
	if(empty($classitem ))
		return $ret;
	$groupid = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT main.parentid FROM ".tname('siteclass')." main where main.classid=".$classitem['parentid']));
	if($groupid == 0) 
		$isSecClass=1;
	else
		$isThirdClass=1;
	if($isSecClass)
		return $ret;

	if(!file_exists( S_ROOT.'./data/sitecache/'.$classid.'/site_cache_'.$classid.'_page1.txt'))
	{
		include_once(S_ROOT.'./source/function_cache.php');
		site_cache_3classid($classid);		
	}
	$count=sreadfile(S_ROOT.'./data/sitecache/'.$classid.'/site_cache_'.$classid.'_count.txt');
	$pages =$count/$_SC['bookmark_show_maxnum']+(($count%$_SC['bookmark_show_maxnum'])?1:0);
     
	$randsrc = array();

	for($i=1;$i<=$pages;$i++){
		$tmp = unserialize(sreadfile(S_ROOT.'./data/sitecache/'.$classid.'/site_cache_'.$classid.'_page'.$i.'.txt'));
		$randsrc=array_merge($randsrc,$tmp);
	}
	//remove self
	foreach($randsrc as $k=>$v){
		if($v['id']==$siteid){
			unset($randsrc[$k]);
			break;
		}
	}
	$ret = sarray_rand($randsrc,$_SC['related_site_num']);
	return $ret;
}
//bookmark获取相关网站
/*
	bmid-bookmark的id
	siteid-如果存在的bookmark的siteid
	tags-bookmark的tag array
*/
function getrelatesiteforbookmark($bmid,$siteid,$classid,$tags)
{
	
	global $_SGLOBAL,$_SC;
	$siteids=array();
	$ret = array();
	if($classid&&$siteid){
		return 	getrelatesite($classid,$siteid);
	}
	
	foreach ($tags as $tagid => $tagname) {
		  $q=$_SGLOBAL['db']->query("SELECT main.siteid FROM ".tname('sitetagsite')." main where main.tagid=".$tagid." AND main.uid !=".$_SGLOBAL['supe_uid']);
		  while($s = $_SGLOBAL['db']->fetch_array($q))
		  {
			if($s['siteid']!=$siteid)
				$siteids[]=$s['siteid'];
		  }		
	}
	
	$siteids=array_unique($siteids);
	$siteids = sarray_rand($siteids,$_SC['today_related_site_num']);
	
	foreach($siteids as $k => $id) {
		$ret[]=getsite($id);
	}
	return $ret;
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
