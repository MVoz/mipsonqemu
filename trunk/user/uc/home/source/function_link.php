<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//���link
function link_post($POST, $olds=array()) {
	global $_SGLOBAL, $_SC, $space,$_GET;
    global $browserid;	
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
		$POST['description'] = getstr($POST['description'], 250, 1,1, 1);
	}
	$message = $POST['description'];
	
	//����
	$linkarr = array(
		'link_subject' => $POST['subject'],		
	);
	/*
	//û����д�κζ���
	$ckmessage = preg_replace("/(\<div\>|\<\/div\>|\s|\&nbsp\;|\<br\>|\<p\>|\<\/p\>)+/is", '', $message);
	if(empty($ckmessage)) {
		return false;
	}
	*/	
			//���ӻ��޸�link
			/*
			olds:
			1:����linkʱ��Ϊ��
			2:�޸�linkkʱ����ʾ��item
			*/
			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 1024, 1, 1, 1);	//�������
			$linkarr['url']=$POST['address'];
			$linkarr['hashurl']=qhash($linkarr['url']);
			$linkarr['md5url']=md5($linkarr['url']);
			//����Ƿ��Ѵ���
			if(checklinkexisted($linkarr))
			{
				return -1;//link existed
			}

			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//�������
			
			//link ��
			$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
			$linkarr['username'] =$_SGLOBAL['supe_username'];
			$linkarr['link_dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$linkarr['link_description'] = $message;
			$linkarr['origin'] = $_SC['link_origin_link'];


            //$linkarr['hashurl']=qhash($linkarr['url']);
			//$linkarr['md5url']=md5($linkarr['url']);
			$linkarr=setlinkimagepath($linkarr);
			$linkarr['verify']=$_SC['link_verify_undo'];
			if(empty($olds)){
				//����һ��LINK				
				$linkid = inserttable('link', $linkarr, 1);
			}else{
				//�޸�һ��LINK
				updatetable('link',$linkarr, array('linkid'=>$olds['linkid']));
				$linkid = $olds['linkid'];
			}
			//tag
			$tagarr=link_tag_batch($linkid,$POST['tag']);
			//update tag
			$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
			$linkarr['link_tag']=$tag;
			updatetable('link',array('link_tag'=>$tag), array('linkid'=>$linkid));
	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $linkarr;
}
//����tag
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

//���link�Ƿ��Ѵ���
function  checklinkexisted($linkarr)
{
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
		$query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." WHERE hashurl=".$linkarr['hashurl']." AND  md5url='".$linkarr['md5url']."' AND  url='".$linkarr['url']."'");
		if($value=$_SGLOBAL['db']->fetch_array($query))
			return 1;
		return 0;
}

function   updatevisitstat($bmid){
//����bookmark����ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    $_SGLOBAL['db']->query("UPDATE ".tname('bookmark')." SET visitnums=visitnums+1 WHERE bmid=".$bmid);
	    $query=$_SGLOBAL['db']->query("SELECT * from ".tname('bookmark')." WHERE  bmid=".$bmid);
        $link=$_SGLOBAL['db']->fetch_array($query);
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET viewnum=viewnum+1 WHERE linkid=".$link['linkid']);
//����������ʱ��
        $_SGLOBAL['db']->query("UPDATE ".tname('bookmark')." SET lastvisit=".$_SGLOBAL['timestamp']." WHERE bmid=".$bmid);
}
function   updatelinkupnum($linkid){
//����link��������ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET up=up+1 WHERE linkid=".$linkid);
}
function   updatelinkdownnum($linkid){
//����link���ȡ���ͳ����Ϣ
	    global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET down=down+1 WHERE linkid=".$linkid);
}
function link_delete_tag($linkid)
{
	global $_SGLOBAL,$_SC;
	//����tag
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('linktaglink')." WHERE linkid=".$linkid);
	$updatetagids=array();
	while($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('linktag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	$_SGLOBAL['db']->query("DELETE  from ".tname('linktaglink')." WHERE linkid=".$linkid);
}
/*
	1:����Ա����ɾ���κ����ӣ������Ȳο��ղ���������ղ���>0,��ɾ��
	2:��û��ͨ����֤��վ�㣬�����ɾ��
*/
function deletelink($linkid){
	//����link
	global $_SGLOBAL,$_SC;
	$link_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." main WHERE  main.linkid= ".$linkid);
	$linkitem=$_SGLOBAL['db']->fetch_array($link_query);
	if(empty($linkitem))
		return 0;
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
		case $_SC['link_verify_failed']:
				 $_SGLOBAL['db']->query("DELETE  from ".tname('link')." WHERE linkid=".$linkid);
				link_delete_tag($linkid);
		break;
	}

	return 1;
}
function link_pass($link)
{
	global $_SGLOBAL,$_SC;
	$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET verify=".$_SC['link_verify_passed']." WHERE linkid=".$link['linkid']);
}

function convertlinktag($linkid,$tag)
{
		$ntag='';
		if(!empty($tag)&&!preg_match("/^a\:\d+\:{\S+/i",$tag))
		{
			//tag
			$tagarr=link_tag_batch($linkid,$tag);
			//update tag
			$ntag = empty($tagarr)?'':addslashes(serialize($tagarr));
			updatetable('link',array('link_tag'=>$ntag), array('linkid'=>$linkid));
			return $ntag;
		}
		return $tag;
}
?>
