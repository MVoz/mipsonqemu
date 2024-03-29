<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./source/function_site.php');
//添加书签
function bookmark_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET;
    global $browserid;	
	//操作者角色切换
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}
	//取适当个数的字符串
	//1:检查是目录还是书签
	//2:subject
	//3:url
	//4:description
	//5:tag 取前128
	if(!isset($POST['category'])){
		//修改bookmark目录
		$POST['subject'] = mb_substr(($POST['subject']), 0, $_SGLOBAL['browser'][$browserid][dirlen], 'UTF-8');
	}else{
		switch($POST['category']){
				case $_SC['bookmark_type_site']://增加或修改一个bookmark
					$POST['subject'] = mb_substr(($POST['subject']), 0, $_SGLOBAL['browser'][$browserid][titlelen], 'UTF-8');
				break;
				case $_SC['bookmark_type_dir']://增加一个目录
					$POST['subject'] = mb_substr(($POST['subject']), 0, $_SGLOBAL['browser'][$browserid][dirlen], 'UTF-8');
				break;
		}

	}

	//对输入的address description tag进行限制
	$POST['address']= mb_substr(trim($POST['address']), 0, $_SGLOBAL['browser'][$browserid][urllen], 'UTF-8');
	$POST['description']= mb_substr(trim($POST['description']), 0, $_SGLOBAL['browser'][$browserid][deslen], 'UTF-8');
	$POST['tag'] =  mb_substr(trim($POST['tag']), 0, $_SGLOBAL['browser'][$browserid][taglen], 'UTF-8');

	//标题
	if($_SGLOBAL['client'])
		$POST['subject'] = getstr(($POST['subject']), 0, 1, 1, 1);
	else
		$POST['subject'] = getstr(trim($POST['subject']), 0, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');
		
	

	//内容
	if($_SGLOBAL['mobile']) {
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr($POST['description'], 0, 1, 1, 1);
	}
	$message = $POST['description'];
	
	//主表
	$bookmarkarr = array(
		'subject' => $POST['subject'],	
		'lastvisit' => $_SGLOBAL['timestamp']
	);
	
	//没有填写任何东西
	/*
	$ckmessage = preg_replace("/(\<div\>|\<\/div\>|\s|\&nbsp\;|\<br\>|\<p\>|\<\/p\>)+/is", '', $message);
	if(empty($ckmessage)) {
		return false;
	}
	*/
		
//	if($olds['bmid']) {
		if(!isset($POST['category'])){
			//修改bookmark目录
			if(empty($olds))
				showmessage('error_operation');
			$bmid = $olds['bmid'];
			$bookmarkarr['uid'] = $olds['uid'];
			$bookmarkarr['groupid']=$olds['groupid'];
			$bookmarkarr['description'] = $message;
			//只修改bookmark目录
			updatetable('bookmark', $bookmarkarr, array('bmid'=>$bmid,'type'=>$_SC['bookmark_type_dir']));	
			setbookmarkmodified();
			$fuids = array();
		}else{
			//增加bookmark或者bookmark目录
			/*
			olds:
			1:增加bookmark时，表是父目录的item
			2:修改bookmark时，表示该item
			3:empty时，表示是在根目录增加item
			*/
			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//语词屏蔽
			
			$POST['address'] = handleUrlString($POST['address']);

			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 0, 1, 1, 1);	//语词屏蔽
			
			$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
			$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$bookmarkarr['description'] = $message;
			$bookmarkarr['type'] = $POST['category'];
			$bookmarkarr['browserid']=empty($olds)?$browserid:$olds['browserid'];

			$linkarr=array();
			$linkarr['url']=$POST['address'];
			$linkarr['hashurl']=qhash($linkarr['url']);
			$linkarr['md5url']=md5($linkarr['url']);

			switch($POST['category']){
				case $_SC['bookmark_type_site']://增加或修改一个bookmark
						//link 表
						$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
						$linkarr['username'] =$_SGLOBAL['name'];
						$linkarr['link_dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
						
						$linkarr=setlinkimagepath($linkarr);
						if($_GET['ac']=='bmdir')
						{
							//增加bookmark
							$linkarr['initaward'] =$linkarr['award']=$_SC['link_award_initial_value'];
							$linkid=bookmark_link_process(0,$linkarr);
						//插入bookmark
							$bookmarkarr['linkid'] = $linkid;
							//bookmark的level深度，父目录深度+1
							$bookmarkarr['level'] = empty($olds)?1:($olds['level']+1);
							//bookmark不需要检测深度，因为目录能建立，bookmark肯定可以建立
							//检测是否超出最大允许数
							$count=0;
							if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_'.$browserid.'_'.$groupid.'.txt')){
								$count = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('bookmark')." main "." where main.uid=".$_SGLOBAL['supe_uid']." AND main.browserid=".$browserid." AND main.parentid=".(empty($olds)?0:$olds['groupid'])),0);
							}else{
								$bookmarklist = unserialize(sreadfile(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_'.$browserid.'_'.$groupid.'.txt'));
								$count=$bookmarklist['totalcount'];
							}							
							include_once(S_ROOT.'./data/data_browser.php');
							if($count>=$_SGLOBAL['browser'][$browserid]['maxchild'])
							{
								return $_SC['error']['err_bookmark_add_overflow'];
							}
							$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
							
							$bmid = inserttable('bookmark', $bookmarkarr, 1);
							setbookmarkmodified();
							setbookmarknum('linknum',1);
						}else{
							$linkid=bookmark_link_process($olds['linkid'],$linkarr);
						//插入bookmark
							$bookmarkarr['linkid'] = $linkid;				
						//修改bookmark
							$bookmarkarr['parentid'] = $olds['parentid'];
							//if($linkid!=$olds['linkid'])
							{
								updatetable('bookmark', $bookmarkarr, array('bmid'=>$olds['bmid']));
								setbookmarkmodified();
							}
							$bmid =$olds['bmid'];
						}	
						//tag
						$tagarr=bookmark_tag_batch($bmid,$POST['tag']);
						//update tag
						$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
						updatetable('bookmark', array('tag'=>$tag), array('bmid'=>$bmid));
						//显示对应的目录
						$bookmarkarr['groupid']=empty($olds)?0:$olds['groupid'];
						$bookmarkarr['bmid']= $bmid;
				break;
				case $_SC['bookmark_type_dir']://增加一个目录
						$maxGroupid=getMaxGroupid($_SGLOBAL['supe_uid']);
						//插入bookmark
						$bookmarkarr['groupid'] = ($maxGroupid+1);
						//bmdir的level深度，父目录深度+1
						$bookmarkarr['level'] = empty($olds)?1:($olds['level']+1);
						//检测深度
						include_once(S_ROOT.'./data/data_browser.php');
						if($bookmarkarr['level']>=$_SGLOBAL['browser'][$browserid]['maxlev'])
						{
							return $_SC['error']['err_bmdir_add_overflow'];
						}
						$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
						$bmid = inserttable('bookmark', $bookmarkarr, 1);
						$bookmarkarr['bmid']= $bmid;
						setbookmarkmodified();
						setbookmarknum('bmdirnum',1);
				break;
			}
		}

	//角色切换
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $bookmarkarr;
}
//获得用户最大的groupid
function getMaxGroupid($uid){
	global $_SGLOBAL,$_SC;
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid=".$uid." AND type=".$_SC['bookmark_type_dir']." ORDER BY groupid DESC limit 1 ");
	$values=$_SGLOBAL['db']->fetch_array($query);
	return (empty($values)?(8000-1):$values['groupid']);
}
//处理tag
function bookmark_tag_batch($id,$tags)
{
		global $_SGLOBAL;
		$uid = $_SGLOBAL['supe_uid'];
		$tagarr = array();
		$now_tag =array();
		$now_tag_1 = empty($tags)?array():array_unique(explode(' ', $tags));
		
		//去除tag中特殊字符,如'
		foreach ($now_tag_1 as $tagname) {
			if(!preg_match('/^([\x7f-\xff_-]|\w){3,20}$/', $tagname)) continue;
			$pos = strpos($tagname, '\'');
			if($pos===false){
			}else
				$now_tag[] = $tagname;
		}
		//if(empty($now_tag)) return $tagarr;
		//获取原来的tags
		$query=$_SGLOBAL['db']->query("SELECT main.* FROM ".tname('bookmark')." main WHERE main.bmid=".$id." AND main.uid=".$_SGLOBAL['supe_uid']);
		$result = $_SGLOBAL['db']->fetch_array($query);
		if(empty($result))
			return $tagarr;
		
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
				 $_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE bmid=".$id.' AND tagid='.$k);			
			  }	  
			// $_SGLOBAL['db']->query("UPDATE ylmf_sitetag SET totalnum=totalnum-1 WHERE tagid IN (".self::simplode(array_keys($need_delete_tags)).")");
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
					//bookmark的tag不进入统计
					'sitetotalnum' => 0,
					'linktotalnum' => 0,
				);
				if ($tagid=inserttable('sitetag', $setarr, 1))
				{
					$tagarr[$tagid] = $tagname;
				}
			}
			
			else {
				if(empty($vtags[$vkey]['close'])) {
					$tagid = $vtags[$vkey]['tagid'];
					$tagarr[$tagid] = $tagname;
				}
			}

		}
		//bookmark的tag不进入统计
		//if($updatetagids) 
		//	$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum+1 WHERE tagid IN (".self::simplode($updatetagids).")");
		$tagids = array_keys($tagarr);
		$inserts = array();
		foreach ($tagids as $tagid) {
			$inserts[] = "('$tagid','$id','$uid')";
		}
		if($inserts) 
			$_SGLOBAL['db']->query("REPLACE INTO ".tname('sitetagsite')." (tagid,bmid,uid) VALUES ".implode(',', $inserts));

		return $tagarr;	
}
/*
function bookmark_tag_batch($bmid, $tags) {

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
		$inserts[] = "('$tagid','$bmid','$_SGLOBAL[supe_uid]')";
	}
	if($inserts) $_SGLOBAL['db']->query("REPLACE INTO ".tname('linktagbookmark')." (tagid,bmid,uid) VALUES ".implode(',', $inserts));

	return $tagarr;
}
*/

//屏蔽html
function checkhtml($html) {
	$html = stripslashes($html);
	if(!checkperm('allowhtml')) {
		
		preg_match_all("/\<([^\<]+)\>/is", $html, $ms);

		$searchs[] = '<';
		$replaces[] = '&lt;';
		$searchs[] = '>';
		$replaces[] = '&gt;';
		
		if($ms[1]) {
			$allowtags = 'img|a|font|div|table|tbody|caption|tr|td|th|br|p|b|strong|i|u|em|span|ol|ul|li|blockquote|object|param|embed';//允许的标签
			$ms[1] = array_unique($ms[1]);
			foreach ($ms[1] as $value) {
				$searchs[] = "&lt;".$value."&gt;";
				$value = shtmlspecialchars($value);
				$value = str_replace(array('\\','/*'), array('.','/.'), $value);
				$value = preg_replace(array("/(javascript|script|eval|behaviour|expression)/i", "/(\s+|&quot;|')on/i"), array('.', ' .'), $value);
				if(!preg_match("/^[\/|\s]?($allowtags)(\s+|$)/is", $value)) {
					$value = '';
				}
				$replaces[] = empty($value)?'':"<".str_replace('&quot;', '"', $value).">";
			}
		}
		$html = str_replace($searchs, $replaces, $html);
	}
	$html = addslashes($html);
	
	return $html;
}
function bookmark_link_process($linkid,$arr){
    //检查此url是否已存在
	global $_SGLOBAL,$_SC;
	$link=array();
    if($linkid)//修改link项
    {
		 $link=getlink($linkid);
		 if(!empty($link)){
			if($link['siteid']==0){
				//此link不在site中
				if(($link['hashurl']==$arr['hashurl'])&&($link['url']==$arr['url']))//无需对link表做改动
					return $link['linkid'];
				else{
					//将old link所在的表记数减一
					 $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum-1 WHERE linkid=".$link['linkid']);
				}
			}else{
				//此link在site中
				 $site_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('site')." WHERE id= ".$link['siteid']);
				 $site = $_SGLOBAL['db']->fetch_array($site_query);
				 if(($site['hashurl']==$arr['hashurl'])&&($site['url']==$arr['url']))//无需对link表做改动
					return $linkid;
				else{
					//将site所在的表记数减一
					 $_SGLOBAL['db']->query("UPDATE ".tname('site')." SET storenum=storenum-1 WHERE id=".$site['id']);
				}
			}
		 }	 
    }
   
	$link_query=$_SGLOBAL['db']->query("SELECT linkid,siteid FROM ".tname('link')." WHERE hashurl= ".$arr['hashurl']." and md5url='".$arr['md5url']."'");
	$link = $_SGLOBAL['db']->fetch_array($link_query);
    if(empty($link)){        
		//ramen 20100912 检查site站点是否含此link
		$site_query=$_SGLOBAL['db']->query("SELECT *,id as siteid FROM ".tname('site')." WHERE hashurl= ".$arr['hashurl']." and url='".$arr['url']."'");
		$site=$_SGLOBAL['db']->fetch_array($site_query);
		if($site['siteid'])//site站点有含此link
		{
			$arr['siteid'] = $site['siteid'];
			$arr['storenum']=0;
			$arr['link_tag'] = '';
			$arr['link_subject'] = '';
			$arr['link_description'] = '';	
			$arr['url'] = '';	
			$arr['up'] = 0;
			$arr['down'] = 0;
			$arr['initaward'] = 0;
			$arr['award'] = 0;
			/*
			$arr['link_tag'] = $site['tag'];
			$arr['link_subject'] = $site['name'];
			$arr['link_description'] = $site['remark'];	
			$arr['picflag'] = $site['picflag'];	
			$arr['pic'] = $site['pic'];
			$arr['md5url'] = $site['md5url'];	
			$arr['hashurl'] = $site['hashurl'];	
			*/
			//$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET storenum=storenum+1 WHERE id=".$site['siteid']);	
			updatesitestorenum($site['siteid'],1);
		}else{
			$arr['storenum'] = '1';
		}
		$linkid = inserttable('link', $arr, 1);
        return $linkid;
    }else
    {
        //update 总数
		if($link['siteid'])//此link在site中
			updatesitestorenum($link['siteid'],1);
		else
			$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum+1 WHERE linkid=".$link['linkid']);
			
        return $link['linkid'];
    }

}
function deletebookmark($bmid){
	//处理link
	 global $_SGLOBAL;
	$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." sub on main.linkid=sub.linkid WHERE bmid= ".$bmid);
	$link=$_SGLOBAL['db']->fetch_array($query);
	if(empty($link))
		return 0;
	//如果link在site中，只需要更新site即可
	if($link['siteid'])
		updatesitestorenum($link['siteid'],0);
	else
		$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum-1 WHERE linkid=".$link['linkid']);
	//处理tag
	//bookmark的统计不进入sitetag中
	/*
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('sitetagsite')." WHERE bmid=".$bmid);
	$updatetagids=array();
	while($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('sitetag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	*/
	$_SGLOBAL['db']->query("DELETE  from ".tname('sitetagsite')." WHERE bmid=".$bmid);
	//处理bookmark
	$_SGLOBAL['db']->query("DELETE  from ".tname('bookmark')." WHERE bmid=".$bmid);

	 //更新统计
	 setbookmarkmodified();
	 setbookmarknum('linknum',0);

	return 1;
}
function deletebookmarkdir($bmid)
{
	//获取自己的groupid
	 global $_SGLOBAL,$_SC;
	 $query =$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE bmid= ".$bmid);
	 $link=$_SGLOBAL['db']->fetch_array($query);
	 $groupid=$link['groupid'];
	 $browserid=$link['browserid'];
	 global $log;
	 $log->debug('$ucnewpm',$groupid." ".$browserid." ".$bmid);
	 $query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE parentid=".$groupid." AND browserid=".$browserid." AND uid=".$_SGLOBAL['supe_uid']);
	 while($value=$_SGLOBAL['db']->fetch_array($query))
	 {
		switch($value['type'])
		 {
			case $_SC['bookmark_type_dir']:
				deletebookmarkdir($value['bmid']);
				break;
			case $_SC['bookmark_type_site']:
				deletebookmark($value['bmid']);
				break;
		 }
	 }
	 //删除自己
	 $_SGLOBAL['db']->query("DELETE FROM ".tname('bookmark')." WHERE bmid= ".$bmid);
	
	 //更新统计
	 setbookmarkmodified();
	 setbookmarknum('bmdirnum',0);

	 return 1;
}
function clearbookmark($browserid)
{
	 global $_SGLOBAL,$_SC;
	 $query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE parentid=0 AND browserid=".$browserid." AND uid=".$_SGLOBAL['supe_uid']);
	 while($value=$_SGLOBAL['db']->fetch_array($query))
	 {
		switch($value['type'])
		 {
			case $_SC['bookmark_type_dir']:
				deletebookmarkdir($value['bmid']);
				break;
			case $_SC['bookmark_type_site']:
				deletebookmark($value['bmid']);
				break;
		 }
	 }
	 return 1;
}

/*
	设置bookmark修改标志，如果用户bookmark有关键项的改动，重新设置一下space的lastmodified
*/
function setbookmarkmodified()
{
	global $_SGLOBAL;
	$spacearr = array(
		'lastmodified' => $_SGLOBAL['supe_timestamp'],		
	);
	updatetable('space', $spacearr, array('uid'=>$_SGLOBAL['supe_uid']));		
	//删除本用户bookmark的cache
	deldir(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid']);
	/*
	include_once(S_ROOT.'./source/function_cache.php');
	bookmark_cache();
	bmxml_cache();
	bookmark_groupname_cache();
	usermenu_cache();
	*/
}
function setbookmarknum($item,$action)
{
	global $_SGLOBAL;
	switch($action)
	{
		case 0://delete
			$_SGLOBAL['db']->query("UPDATE ".tname('space')." SET ".$item."=".$item."-1 WHERE uid=".$_SGLOBAL['supe_uid']);
		break;
		case 1://add
			$_SGLOBAL['db']->query("UPDATE ".tname('space')." SET ".$item."=".$item."+1 WHERE uid=".$_SGLOBAL['supe_uid']);
		break;
	}
}

?>
