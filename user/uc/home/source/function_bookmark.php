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
		
//	if($olds['bmid']) {
		if(!isset($POST['category'])){
			//�޸�bookmarkĿ¼
			if(empty($olds))
				showmessage('error_operation');
			$bmid = $olds['bmid'];
			$bookmarkarr['uid'] = $olds['uid'];
			$bookmarkarr['groupid']=$olds['groupid'];
			$bookmarkarr['description'] = $message;
			//ֻ�޸�bookmarkĿ¼
			updatetable('bookmark', $bookmarkarr, array('bmid'=>$bmid,'type'=>$_SC['bookmark_type_dir']));	
			setbookmarkmodified();
			$fuids = array();
		}else{
			//����bookmark����bookmarkĿ¼
			/*
			olds:
			1:����bookmarkʱ�����Ǹ�Ŀ¼��item
			2:�޸�bookmarkʱ����ʾ��item
			3:emptyʱ����ʾ���ڸ�Ŀ¼����item
			*/
			$POST['tag'] = shtmlspecialchars(trim($POST['tag']));
			$POST['tag'] = getstr($POST['tag'], 500, 1, 1, 1);	//�������
			
			$POST['address'] = handleUrlString($POST['address']);

			$POST['address'] = shtmlspecialchars(trim($POST['address']));
			$POST['address'] = getstr($POST['address'], 1024, 1, 1, 1);	//�������
			
			$bookmarkarr['uid'] = $_SGLOBAL['supe_uid'];
			$bookmarkarr['dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
			$bookmarkarr['description'] = $message;
			$bookmarkarr['type'] = $POST['category'];
			$bookmarkarr['browserid']=empty($olds)?$browserid:$olds['browserid'];
			switch($POST['category']){
				case $_SC['bookmark_type_site']://���ӻ��޸�һ��bookmark
						//link ��
						$linkarr['postuid'] = $_SGLOBAL['supe_uid'];
						$linkarr['username'] =$_SGLOBAL['supe_username'];
						$linkarr['link_dateline'] = empty($POST['dateline'])?$_SGLOBAL['timestamp']:$POST['dateline'];
						$linkarr['url']=$POST['address'];
						$linkarr['hashurl']=qhash($linkarr['url']);
						$linkarr['md5url']=md5($linkarr['url']);
						$linkarr=setlinkimagepath($linkarr);
						if($_GET['ac']=='bmdir')
						{
							//����bookmark
							$linkid=bookmark_link_process(0,$linkarr);
						//����bookmark
							$bookmarkarr['linkid'] = $linkid;				
							$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
							$bmid = inserttable('bookmark', $bookmarkarr, 1);
							setbookmarkmodified();
							setbookmarknum('linknum',1);
						}else{
							$linkid=bookmark_link_process($olds['linkid'],$linkarr);
						//����bookmark
							$bookmarkarr['linkid'] = $linkid;				
						//�޸�bookmark
							$bookmarkarr['parentid'] = $olds['parentid'];
							if($linkid!=$olds['linkid'])
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
						//��ʾ��Ӧ��Ŀ¼
						$bookmarkarr['groupid']=empty($olds)?0:$olds['groupid'];
				break;
				case $_SC['bookmark_type_dir']://����һ��Ŀ¼
						$maxGroupid=getMaxGroupid($_SGLOBAL['supe_uid']);
						//����bookmark
						$bookmarkarr['groupid'] = ($maxGroupid+1);		
						$bookmarkarr['parentid'] = empty($olds)?0:$olds['groupid'];
						$bmid = inserttable('bookmark', $bookmarkarr, 1);
						setbookmarkmodified();
						setbookmarknum('bmdirnum',1);
				break;
			}
		}

	//��ɫ�л�
	if(!empty($__SGLOBAL)) $_SGLOBAL = $__SGLOBAL;

	return $bookmarkarr;
}
//����û�����groupid
function getMaxGroupid($uid){
	global $_SGLOBAL,$_SC;
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid=".$uid." AND type=".$_SC['bookmark_type_dir']." ORDER BY groupid DESC limit 1 ");
	$values=$_SGLOBAL['db']->fetch_array($query);
	return (empty($values)?(8000-1):$values['groupid']);
}
//����tag
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
function bookmark_link_process($linkid,$arr){
    //����url�Ƿ��Ѵ���
	global $_SGLOBAL,$_SC;
	$link=array();
    if($linkid)//�޸�link��
    {
		 $link_query=$_SGLOBAL['db']->query("SELECT * FROM ".tname('link')." WHERE linkid= ".$linkid);
		 $link = $_SGLOBAL['db']->fetch_array($link_query);
		 if(!empty($link)){
				if(($link['hashurl']==$arr['hashurl'])&&($link['url']==$arr['url']))//�����link�����Ķ�
					return $link['linkid'];
				else{
					//��old link���ڵı������һ
					 $_SGLOBAL['db']->query("UPDATE ".tname('link')." SET storenum=storenum-1 WHERE linkid=".$link['linkid']);
				}
		 }	 
    }
   
	$link_query=$_SGLOBAL['db']->query("SELECT linkid FROM ".tname('link')." WHERE hashurl= ".$arr['hashurl']." and url='".$arr['url']."'");
	$link = $_SGLOBAL['db']->fetch_array($link_query);
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
	$query=	$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." main left join ".tname('link')." sub on main.linkid=sub.linkid WHERE bmid= ".$bmid);
	$link=$_SGLOBAL['db']->fetch_array($query);
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

	 //����ͳ��
	 setbookmarkmodified();
	 setbookmarknum('linknum',0);

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
	
	 //����ͳ��
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
	process the url string:
	example:http://www.sohu.com === http://www.sohu.com/
*/
function handleUrlString($url)
{
	$url=trim($url);
	$len=strlen($url);
	while($url[$len-1]=='/')
	{
		$url=substr($url, 0, $len-1); 
		$len=strlen($url);
	}
	return $url;
}
/*
	����bookmark�޸ı�־������û�bookmark�йؼ���ĸĶ�����������һ��space��lastmodified
*/
function setbookmarkmodified()
{
	global $_SGLOBAL;
	$spacearr = array(
		'lastmodified' => $_SGLOBAL['timestamp'],		
	);
	updatetable('space', $spacearr, array('uid'=>$_SGLOBAL['supe_uid']));		
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
