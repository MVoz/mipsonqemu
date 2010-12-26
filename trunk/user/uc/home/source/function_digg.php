<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//���digg
function digg_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET;
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
		$POST['description'] = getstr(trim($POST['description']), 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr(trim($POST['description']), 220, 1,1, 1);
	}
	//$message = $POST['description'];
	$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
	$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//�������

	$POST['address'] = shtmlspecialchars(trim($POST['address']));
	$POST['address'] = getstr($POST['address'], 500, 1, 1, 1);	//�������
	//����
	$diggarr = array(
		'subject' => $POST['subject'],	
		'postuid' => $_SGLOBAL['supe_uid'],
		//'username'=> $_SGLOBAL['supe_username'],
		'username'=> $_SGLOBAL['name'],
		'description' => $POST['description'],
		'url'=>$POST['address'],
		'hashurl'=>qhash($POST['address']),
		'md5url'=>md5($POST['address']),
//		'categoryid' => $POST['category']
	);
	$diggarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];

		//����ͼƬ
	//$titlepic = '';
	//ͼƬ��ַ
	//��ȡ�ϴ���ͼƬ

	if(!empty($POST['picids'])) {
		$picids = array_keys($POST['picids']);
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('pic')." WHERE picid IN (".simplode($picids).") AND uid='$_SGLOBAL[supe_uid]'");
		if ($value = $_SGLOBAL['db']->fetch_array($query)) {
			if(empty($titlepic) && $value['thumb']) {
				//$titlepic = $value['filepath'].'.thumb.jpg';
				$diggarr['picflag'] = $value['remote']?2:1;
			}
			$diggarr['pic'] = pic_get($value['filepath'], $value['thumb'], $value['remote'], 1);
		}
		if(empty($titlepic) && $value) {
			//$titlepic = $value['filepath'];
			$diggarr['picflag'] = $value['remote']?2:1;
		}
	}



	$diggid=$olds['diggid'];
		//���ӻ�༭digg
			/*
			olds:
			1:����bookmarkʱ��Ϊ��
			2:�޸�bookmarkʱ����ʾ��item
			*/
	if(empty($olds)){
		//����Ƿ��Ѵ���
		if(!is_digg_exist($diggarr['url'])){
			$diggid = inserttable('digg', $diggarr, 1);
			include_once(S_ROOT.'./source/function_feed.php');
			feed_publish($diggid, 'diggid', 1);
		}else{
			showmessage('digg_is_existed');
		}
	}else{
		updatetable('digg', $diggarr, array('diggid'=>$diggid));
	}				
	$tagarr=digg_tag_batch($diggid,$POST['tag']);
	$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
	updatetable('digg', array('tag'=>$tag), array('diggid'=>$diggid));
	//����digg cache
	include_once(S_ROOT.'./source/function_cache.php');
	if(empty($olds)){
		//����
		digg_cache(1,0,0,0);
		digg_cache(1,0,$_SGLOBAL['supe_uid'],0);
	}else{
		//�޸�
		digg_cache(0,1,0,$diggid);
		digg_cache(0,1,$_SGLOBAL['supe_uid'],$diggid);
	}
		
	//if(empty($olds))
	//	digg_cache($diggarr['categoryid'],$olds['categoryid'],$_SGLOBAL['supe_uid']);
	//else
	//	digg_cache($diggarr['categoryid'],0,$_SGLOBAL['supe_uid']);
	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $diggarr;
}

//����tag
function digg_tag_batch($diggid, $tags) {
	global $_SGLOBAL;

	$tagarr = array();
	$tagnames = empty($tags)?array():array_unique(explode(' ', $tags));
	if(empty($tagnames)) return $tagarr;

	$vtags = array();
	$query = $_SGLOBAL['db']->query("SELECT tagid, tagname, close FROM ".tname('diggtag')." WHERE tagname IN (".simplode($tagnames).")");
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
			$tagid = inserttable('diggtag', $setarr, 1);
			$tagarr[$tagid] = $tagname;
		} else {
			if(empty($vtags[$vkey]['close'])) {
				$tagid = $vtags[$vkey]['tagid'];
				$updatetagids[] = $tagid;
				$tagarr[$tagid] = $tagname;
			}
		}
	}
	if($updatetagids) $_SGLOBAL['db']->query("UPDATE ".tname('diggtag')." SET totalnum=totalnum+1 WHERE tagid IN (".simplode($updatetagids).")");
	$tagids = array_keys($tagarr);
	$inserts = array();
	foreach ($tagids as $tagid) {
		$inserts[] = "('$tagid','$diggid','$_SGLOBAL[supe_uid]')";
	}
	if($inserts) $_SGLOBAL['db']->query("REPLACE INTO ".tname('diggtagdigg')." (tagid,diggid,uid) VALUES ".implode(',', $inserts));

	return $tagarr;
}
function   updatediggdownnum($diggid){
	//����digg��ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    
		include_once(S_ROOT.'./source/function_feed.php');
		if(feed_publish($diggid, 'downdiggid', 1))
		{
			$_SGLOBAL['db']->query("UPDATE ".tname('digg')." SET downnum=downnum+1 WHERE diggid=".$diggid);
			return 1;
		}
		return 0;
}
function   updatediggupnum($diggid){
	//����digg��ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return 0;		   
		include_once(S_ROOT.'./source/function_feed.php');
		if(feed_publish($diggid, 'updiggid', 1))
		{
			 $_SGLOBAL['db']->query("UPDATE ".tname('digg')." SET upnum=upnum+1 WHERE diggid=".$diggid);
			 return 1;
		}
		return 0;
}
function   updatediggviewnum($diggid){
	//����digg��ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    $_SGLOBAL['db']->query("UPDATE ".tname('digg')." SET viewnum=viewnum+1 WHERE diggid=".$diggid);
}
function deletedigg($diggid){
	global $_SGLOBAL;
	//����tag
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('diggtagdigg')." WHERE diggid=".$diggid);
	$updatetagids=array();
	if($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('diggtag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	$_SGLOBAL['db']->query("DELETE  from ".tname('diggtagdigg')." WHERE diggid=".$diggid);
	//����digg
	$_SGLOBAL['db']->query("DELETE  from ".tname('digg')." WHERE diggid=".$diggid);
	//����digg cache
	include_once(S_ROOT.'./source/function_cache.php');
	//ɾ����
	digg_cache(0,1,0,$diggid);
	digg_cache(0,1,$values['postuid'],$diggid);
	//ȥ��feed
	include_once(S_ROOT.'./source/function_feed.php');
	feed_delete($diggid, 'diggid');
	return 1;
}
function getdiggnumparameter($diggid,$type)
{
		$wherearr = array(
				'diggid'=>$diggid
		);
		return getcount('digg',$wherearr,$type);
}
function is_digg_exist($url)
{
	global $_SGLOBAL;
	if(strlen($url)){
			$hashurl=qhash($url); 
			$md5url=md5($url);
			$diggid=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT diggid FROM ".tname('digg')." WHERE hashurl=".$hashurl." AND md5url='".$md5url."'"));
			if(!empty($diggid))
				return true;
	}
	return false;
}
?>
