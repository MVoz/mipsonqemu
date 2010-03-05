<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_blog.php 13178 2009-08-17 02:36:39Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

//�����ǩ
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
		$POST['description'] = getstr($POST['description'], 0, 1, 0, 1, 1);
	} else {
		$POST['description'] = getstr($POST['description'], 220, 1,1, 1);
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
		'username'=> $_SGLOBAL['supe_username'],
		'description' => $POST['description'],
		'url'=>$POST['address'],
		'category' => $POST['category']
	);
	$diggarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
	$diggid=$olds['diggid'];
		//���ӻ�༭digg
			/*
			olds:
			1:����bookmarkʱ��Ϊ��
			2:�޸�bookmarkʱ����ʾ��item
			*/
	if(empty($olds)){
		$diggid = inserttable('digg', $diggarr, 1);
	}else{

	}				
	$tagarr=digg_tag_batch($diggid,$POST['tag']);
	$tag = empty($tagarr)?'':addslashes(serialize($tagarr));
	updatetable('digg', array('tag'=>$tag), array('diggid'=>$diggid));
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



function bookmark_link_process($bmid,$arr){
    //����url�Ƿ��Ѵ���
	global $_SGLOBAL,$_SC;
    if($bmid)//�޸�bookmark��
    {
		 $link = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." sub on main.linkid=sub.linkid WHERE bmid= ".$bmid));
		 if(!empty($link)){
			if(($link['hashurl']==$arr['hashurl'])&&($link['url']==$arr['url']))//�����link�����Ķ�
				return $link['linkid'];
			else{
				//��old link���ڵı������һ
				 $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum-1 WHERE linkid=".$link['linkid']);
			}
		 }	 
    }
    $link=array();
    $link=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT linkid FROM ".tname('link')." WHERE hashurl= ".$arr['hashurl']." and url='".$arr['url']."'"));
    if(empty($link)){
        $arr['storenum']=1;
		$linkid = inserttable('link', $arr, 1);
        return $linkid;
    }else
    {
        //update ����
	    $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum+1 WHERE linkid=".$link['linkid']);
        return $link['linkid'];
    }

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
function deletebookmark($bmid){
	//����link
	 global $_SGLOBAL;
	$link = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." sub on main.linkid=sub.linkid WHERE bmid= ".$bmid),0);
	if(empty($link))
		return 0;
	$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum-1 WHERE linkid=".$link['linkid']);
	//����tag
	$query=$_SGLOBAL['db']->query("SELECT * from ".tname('linktagbookmark')." WHERE bmid=".$bmid);
	$updatetagids=array();
	while($values=$_SGLOBAL['db']->fetch_array($query))
	{
		$updatetagids[]=$values['tagid'];		
	}
	if($updatetagids)
		$_SGLOBAL['db']->query("UPDATE ".tname('linktag')." SET totalnum=totalnum-1 WHERE tagid IN (".simplode($updatetagids).")");
	$_SGLOBAL['db']->query("DELETE  from ".tname('linktagbookmark')." WHERE bmid=".$bmid);
	//����bookmark
	$_SGLOBAL['db']->query("DELETE  from ".tname('bookmark')." WHERE bmid=".$bmid);
	return 1;
}
function deletebookmarkdir($bmid)
{
	//��ȡ�Լ���groupid
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
	 //ɾ���Լ�
	 $_SGLOBAL['db']->query("DELETE FROM ".tname('bookmark')." WHERE bmid= ".$bmid);
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

?>
