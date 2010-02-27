<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//添加书签
function bookmark_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space;
    global $browserid;	
	//操作者角色切换
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//标题
	$POST['subject'] = getstr(trim($POST['subject']), 80, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');
		
	

	//内容
	if($_SGLOBAL['mobile']) {
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr($POST['description'], 250, 1,1, 1);
	}
	$message = $POST['description'];
	
	//主表
	$bookmarkarr = array(
		'subject' => $POST['subject'],		
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
		updatetable('bookmark', $bookmarkarr, array('bmid'=>$bmid));		
		$fuids = array();
		}else{
			//增加bookmark或者bookmark目录
			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//语词屏蔽

			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 500, 1, 1, 1);	//语词屏蔽
			
			$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
			$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$bookmarkarr['description'] = $message;
			$bookmarkarr['type'] = $POST['category'];
			$bookmarkarr['browserid']=empty($olds)?$browserid:$olds['browserid'];
			switch($POST['category']){
				case $_SC['bookmark_type_site']://增加一个bookmark
				//link 表
				$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
				$linkarr['username'] =$_SGLOBAL['supe_username'];
				$linkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
				$linkarr['url']=$POST['address'];
                $linkarr['hashurl']=qhash($linkarr['url']);
                $linkid=bookmark_link_process($linkarr);
				//$linkid = inserttable('link', $linkarr, 1);
				//插入bookmark
				$bookmarkarr['linkid'] = $linkid;
				$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
                //tag
               	$bookmarkar['tag'] = empty($tagarr)?'':addslashes(serialize($tagarr));
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				$tagarr=bookmark_tag_batch($bmid,$POST['tag']);
				//显示对应的目录
				$bookmarkarr['groupid']=empty($olds)?0:$olds['groupid'];
				break;
				case $_SC['bookmark_type_dir']://增加一个目录
				$maxGroupid=getMaxGroupid($_SGLOBAL['supe_uid']);
				//插入bookmark
				$bookmarkarr['groupid'] = ($maxGroupid+1);		
				$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				break;
			}
		}
/*	} else {
        //根目录
			//增加bookmark或者bookmark目录
			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//语词屏蔽

			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 500, 1, 1, 1);	//语词屏蔽
			
			$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
			$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$bookmarkarr['description'] = $message;
			$bookmarkarr['type'] = $POST['category'];
			$bookmarkarr['browserid']=$browserid;
			switch($POST['category']){
				case $_SC['bookmark_type_site']://增加一个bookmark
				//link 表
				$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
				$linkarr['username'] =$_SGLOBAL['supe_username'];
				$linkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
				$linkarr['url']=$POST['address'];
                $linkarr['hashurl']=qhash($linkarr['url']);
                $linkid=bookmark_link_process($linkarr);
				//$linkid = inserttable('link', $linkarr, 1);
				//插入bookmark
				$bookmarkarr['linkid'] = $linkid;
				$bookmarkarr['parentid'] =0;
                //tag
               	$bookmarkar['tag'] = empty($tagarr)?'':addslashes(serialize($tagarr));
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				$tagarr=bookmark_tag_batch($bmid,$POST['tag']);
				//显示对应的目录
				$bookmarkarr['groupid']=0;
				$bookmarkarr['browserid']=$browserid;
				break;
				case $_SC['bookmark_type_dir']://增加一个目录
				$maxGroupid=getMaxGroupid($_SGLOBAL['supe_uid']);
				//插入bookmark
				$bookmarkarr['groupid'] = ($maxGroupid+1);		
				$bookmarkarr['parentid'] = 0;
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				break;
			}
}
 */
	/*
	$blogarr['blogid'] = $blogid;
	
	//附表	
	$fieldarr = array(
		'message' => $message,
		'postip' => getonlineip(),
		'target_ids' => $POST['target_ids']
	);

	if($olds) {
		//更新
		updatetable('blogfield', $fieldarr, array('blogid'=>$blogid));
	} else {
		$fieldarr['blogid'] = $blogid;
		$fieldarr['uid'] = $blogarr['uid'];
		inserttable('blogfield', $fieldarr);
	}


	*/
	//角色切换
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $bookmarkarr;
}
//获得用户最大的groupid
function getMaxGroupid($uid){
	global $_SGLOBAL,$_SC;
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid=".$uid." AND type=".$_SC['bookmark_type_dir']." ORDER BY groupid DESC limit 1 ");
	$values=$_SGLOBAL['db']->fetch_array($query);
	return (empty($values)?8000:$values['groupid']);
}
//处理tag
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
		$inserts[] = "('$tagid','$bmid')";
	}
	if($inserts) $_SGLOBAL['db']->query("REPLACE INTO ".tname('linktagbookmark')." (tagid,bmid) VALUES ".implode(',', $inserts));

	return $tagarr;
}


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
function bookmark_link_process($arr){
    //检查此url是否已存在
	global $_SGLOBAL,$_SC;
    $link=array();
	$query = $_SGLOBAL['db']->query("SELECT linkid FROM ".tname('link')." WHERE hashurl= ".$arr['hashurl']." and url='".$arr['url']."'");
    $link=$_SGLOBAL['db']->fetch_array($query);
    if(empty($link)){
        $arr['storenum']=1;
		$linkid = inserttable('link', $arr, 1);
        return $linkid;
    }else
    {
        //update 总数
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum+1 WHERE linkid=".$link['linkid']);
        return $link['linkid'];
    }

}
function   updatevisitstat($bmid){
//更新bookmark访问统计信息
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    $_SGLOBAL['db']->query("UPDATE ".tname('bookmark')." SET visitnums=visitnums+1 WHERE bmid=".$bmid);
	    $query=$_SGLOBAL['db']->query("SELECT * from ".tname('bookmark')." WHERE  bmid=".$bmid);
        $link=$_SGLOBAL['db']->fetch_array($query);
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET viewnum=viewnum+1 WHERE linkid=".$link['linkid']);
//更新最后访问时间
        $_SGLOBAL['db']->query("UPDATE ".tname('bookmark')." SET lastvisit=".$_SGLOBAL['timestamp']." WHERE bmid=".$bmid);
}

?>
