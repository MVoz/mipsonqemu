<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//�����ǩ
function bookmark_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space;
	
	//�����߽�ɫ�л�
	$isself = 1;
	if(!empty($olds['uid']) && $olds['uid'] != $_SGLOBAL['supe_uid']) {
		$isself = 0;
		$__SGLOBAL = $_SGLOBAL;
		$_SGLOBAL['supe_uid'] = $olds['uid'];
	}

	//����
	$POST['subject'] = getstr(trim($POST['subject']), 80, 1, 1, 1);
	if(strlen($POST['subject'])<1) $POST['subject'] = sgmdate('Y-m-d');
		
	

	//����
	if($_SGLOBAL['mobile']) {
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = checkhtml($POST['description']);
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 0, 1);
		$POST['description'] = preg_replace(array(
				"/\<div\>\<\/div\>/i",
				"/\<a\s+href\=\"([^\>]+?)\"\>/i"
			), array(
				'',
				'<a href="\\1" target="_blank">'
			), $POST['description']);
	}
	$message = $POST['description'];
	
	//����
	$bookmarkarr = array(
		'subject' => $POST['subject'],		
	);
	
	//û����д�κζ���
	/*
	$ckmessage = preg_replace("/(\<div\>|\<\/div\>|\s|\&nbsp\;|\<br\>|\<p\>|\<\/p\>)+/is", '', $message);
	if(empty($ckmessage)) {
		return false;
	}
	*/
	//���slashes
	$message = addslashes($message);
		
	if($olds['bmid']) {
		if(!isset($POST['category'])){
		//�޸�bookmarkĿ¼
		$bmid = $olds['bmid'];
		$bookmarkarr['uid'] = $olds['uid'];
		$bookmarkarr['groupid']=$olds['groupid'];
		$bookmarkarr['description'] = $message;
		updatetable('bookmark', $bookmarkarr, array('bmid'=>$bmid));		
		$fuids = array();
		}else{
			//����bookmark����bookmarkĿ¼
			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//�������

			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 500, 1, 1, 1);	//�������
			
			$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
			$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$bookmarkarr['description'] = $message;
			$bookmarkarr['type'] = $POST['category'];
			switch($POST['category']){
				case $_SC['bookmark_type_site']://����һ��bookmark
				//link ��
				$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
				$linkarr['username'] =$_SGLOBAL['supe_username'];
				$linkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
				$linkarr['url']=$POST['address'];
				$linkid = inserttable('link', $linkarr, 1);
				//����bookmark
				$bookmarkarr['linkid'] = $linkid;
				$bookmarkarr['parentid'] = $olds['groupid'];
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				//��ʾ��Ӧ��Ŀ¼
				$bookmarkarr['groupid']=$olds['groupid'];
				break;
				case $_SC['bookmark_type_dir']://����һ��Ŀ¼
				$maxGroupid=getMaxGroupid($_SGLOBAL['supe_uid']);
				//����bookmark
				$bookmarkarr['groupid'] = ($maxGroupid+1);		
				$bookmarkarr['parentid'] = $olds['groupid'];
				$bmid = inserttable('bookmark', $bookmarkarr, 1);
				break;
			}
		}
	} else {
		$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
		$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
		$bookmarkarr['description'] = $message;
		$bmid = inserttable('bookmark', $bookmarkarr, 1);
	}
	/*
	$blogarr['blogid'] = $blogid;
	
	//����	
	$fieldarr = array(
		'message' => $message,
		'postip' => getonlineip(),
		'target_ids' => $POST['target_ids']
	);

	if($olds) {
		//����
		updatetable('blogfield', $fieldarr, array('blogid'=>$blogid));
	} else {
		$fieldarr['blogid'] = $blogid;
		$fieldarr['uid'] = $blogarr['uid'];
		inserttable('blogfield', $fieldarr);
	}


	*/
	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $bookmarkarr;
}
//����û�����groupid
function getMaxGroupid($uid){
	global $_SGLOBAL,$_SC;
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid=".$uid." AND type=".$_SC['bookmark_type_dir']." ORDER BY groupid DESC limit 1 ");
	$values=$_SGLOBAL['db']->fetch_array($query);
	return (empty($values)?8000:$values['groupid']);
}
//����tag
function tag_batch($blogid, $tags) {
	global $_SGLOBAL;

	$tagarr = array();
	$tagnames = empty($tags)?array():array_unique(explode(' ', $tags));
	if(empty($tagnames)) return $tagarr;

	$vtags = array();
	$query = $_SGLOBAL['db']->query("SELECT tagid, tagname, close FROM ".tname('tag')." WHERE tagname IN (".simplode($tagnames).")");
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
				'blognum' => 1
			);
			$tagid = inserttable('tag', $setarr, 1);
			$tagarr[$tagid] = $tagname;
		} else {
			if(empty($vtags[$vkey]['close'])) {
				$tagid = $vtags[$vkey]['tagid'];
				$updatetagids[] = $tagid;
				$tagarr[$tagid] = $tagname;
			}
		}
	}
	if($updatetagids) $_SGLOBAL['db']->query("UPDATE ".tname('tag')." SET blognum=blognum+1 WHERE tagid IN (".simplode($updatetagids).")");
	$tagids = array_keys($tagarr);
	$inserts = array();
	foreach ($tagids as $tagid) {
		$inserts[] = "('$tagid','$blogid')";
	}
	if($inserts) $_SGLOBAL['db']->query("REPLACE INTO ".tname('tagblog')." (tagid,blogid) VALUES ".implode(',', $inserts));

	return $tagarr;
}


//����html
function checkhtml($html) {
	$html = stripslashes($html);
	if(!checkperm('allowhtml')) {
		
		preg_match_all("/\<([^\<]+)\>/is", $html, $ms);

		$searchs[] = '<';
		$replaces[] = '&lt;';
		$searchs[] = '>';
		$replaces[] = '&gt;';
		
		if($ms[1]) {
			$allowtags = 'img|a|font|div|table|tbody|caption|tr|td|th|br|p|b|strong|i|u|em|span|ol|ul|li|blockquote|object|param|embed';//����ı�ǩ
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
?>
