<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: function_common.php 13216 2009-08-21 06:06:04Z shirui $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}
include_once(S_ROOT.'./data/data_diggcategory.php');
include_once(S_ROOT.'./data/data_browsertype.php');
include_once(S_ROOT.'./data/data_browser.php');
include_once(S_ROOT.'./data/data_linkerrtype.php');
include_once(S_ROOT.'./data/data_linktoolbartype.php');
include_once(S_ROOT.'./data/data_linktoolbar.php');
include_once(S_ROOT.'./data/data_linkclass.php');
include_once(S_ROOT.'./data/data_siteclass.php');
//debug outpur
function debugOutput($name,$value){
	global $_SGLOBAL;
	if(D_BUG){
			$_SGLOBAL['ramen_debug'][$name]=$value;
	}
}
//SQL ADDSLASHES
function saddslashes($string) {
	if(is_array($string)) {
		foreach($string as $key => $val) {
			$string[$key] = saddslashes($val);
		}
	} else {
		$string = addslashes($string);
	}
	return $string;
}

//取消HTML代码
function shtmlspecialchars($string) {
	if(is_array($string)) {
		foreach($string as $key => $val) {
			$string[$key] = shtmlspecialchars($val);
		}
	} else {
		$string = preg_replace('/&amp;((#(\d{3,5}|x[a-fA-F0-9]{4})|[a-zA-Z][a-z0-9]{2,5});)/', '&\\1',
			str_replace(array('&', '"', '<', '>'), array('&amp;', '&quot;', '&lt;', '&gt;'), $string));
	}
	return $string;
}
//与shtmlspecialchars相反
function unshtmlspecialchars($string) {
	if(is_array($string)) {
		foreach($string as $key => $val) {
			$string[$key] = unshtmlspecialchars($val);
		}
	} else {
		$string =str_replace( array('&amp;', '&quot;', '&lt;', '&gt;'),array('&', '"', '<', '>'), $string);
	}
	return $string;
}

//字符串解密加密
function authcode($string, $operation = 'DECODE', $key = '', $expiry = 0) {

	$ckey_length = 4;	// 随机密钥长度 取值 0-32;
				// 加入随机密钥，可以令密文无任何规律，即便是原文和密钥完全相同，加密结果也会每次不同，增大破解难度。
				// 取值越大，密文变动规律越大，密文变化 = 16 的 $ckey_length 次方
				// 当此值为 0 时，则不产生随机密钥

	$key = md5($key ? $key : UC_KEY);
	$keya = md5(substr($key, 0, 16));
	$keyb = md5(substr($key, 16, 16));
	$keyc = $ckey_length ? ($operation == 'DECODE' ? substr($string, 0, $ckey_length): substr(md5(microtime()), -$ckey_length)) : '';

	$cryptkey = $keya.md5($keya.$keyc);
	$key_length = strlen($cryptkey);

	$string = $operation == 'DECODE' ? base64_decode(substr($string, $ckey_length)) : sprintf('%010d', $expiry ? $expiry + time() : 0).substr(md5($string.$keyb), 0, 16).$string;
	$string_length = strlen($string);

	$result = '';
	$box = range(0, 255);

	$rndkey = array();
	for($i = 0; $i <= 255; $i++) {
		$rndkey[$i] = ord($cryptkey[$i % $key_length]);
	}

	for($j = $i = 0; $i < 256; $i++) {
		$j = ($j + $box[$i] + $rndkey[$i]) % 256;
		$tmp = $box[$i];
		$box[$i] = $box[$j];
		$box[$j] = $tmp;
	}

	for($a = $j = $i = 0; $i < $string_length; $i++) {
		$a = ($a + 1) % 256;
		$j = ($j + $box[$a]) % 256;
		$tmp = $box[$a];
		$box[$a] = $box[$j];
		$box[$j] = $tmp;
		$result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
	}

	if($operation == 'DECODE') {
		if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {
			return substr($result, 26);
		} else {
			return '';
		}
	} else {
		return $keyc.str_replace('=', '', base64_encode($result));
	}
}

//清空cookie
function clearcookie() {
	global $_SGLOBAL;

	obclean();
	ssetcookie('auth', '', -86400 * 365);
	$_SGLOBAL['supe_uid'] = 0;
	$_SGLOBAL['supe_username'] = '';
	$_SGLOBAL['member'] = array();
}

//cookie设置
function ssetcookie($var, $value, $life=0) {
	global $_SGLOBAL, $_SC, $_SERVER;
	setcookie($_SC['cookiepre'].$var, $value, $life?($_SGLOBAL['timestamp']+$life):0, $_SC['cookiepath'], $_SC['cookiedomain'], $_SERVER['SERVER_PORT']==443?1:0);
}

//数据库连接
function dbconnect() {
	global $_SGLOBAL, $_SC;

	include_once(S_ROOT.'./source/class_mysql.php');

	if(empty($_SGLOBAL['db'])) {
		$_SGLOBAL['db'] = new dbstuff;
		$_SGLOBAL['db']->charset = $_SC['dbcharset'];
		$_SGLOBAL['db']->connect($_SC['dbhost'], $_SC['dbuser'], $_SC['dbpw'], $_SC['dbname'], $_SC['pconnect']);
	}
}

//获取在线IP
function getonlineip($format=0) {
	global $_SGLOBAL;

	if(empty($_SGLOBAL['onlineip'])) {
		if(getenv('HTTP_CLIENT_IP') && strcasecmp(getenv('HTTP_CLIENT_IP'), 'unknown')) {
			$onlineip = getenv('HTTP_CLIENT_IP');
		} elseif(getenv('HTTP_X_FORWARDED_FOR') && strcasecmp(getenv('HTTP_X_FORWARDED_FOR'), 'unknown')) {
			$onlineip = getenv('HTTP_X_FORWARDED_FOR');
		} elseif(getenv('REMOTE_ADDR') && strcasecmp(getenv('REMOTE_ADDR'), 'unknown')) {
			$onlineip = getenv('REMOTE_ADDR');
		} elseif(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], 'unknown')) {
			$onlineip = $_SERVER['REMOTE_ADDR'];
		}
		preg_match("/[\d\.]{7,15}/", $onlineip, $onlineipmatches);
		$_SGLOBAL['onlineip'] = $onlineipmatches[0] ? $onlineipmatches[0] : 'unknown';
	}
	if($format) {
		$ips = explode('.', $_SGLOBAL['onlineip']);
		for($i=0;$i<3;$i++) {
			$ips[$i] = intval($ips[$i]);
		}
		return sprintf('%03d%03d%03d', $ips[0], $ips[1], $ips[2]);
	} else {
		return $_SGLOBAL['onlineip'];
	}
}

//判断当前用户登录状态
function checkauth() {
	global $_SGLOBAL, $_SC, $_SCONFIG, $_SCOOKIE, $_SN;

	if($_SGLOBAL['mobile'] && $_GET['m_auth']) $_SCOOKIE['auth'] = $_GET['m_auth'];
	if($_SCOOKIE['auth']) {
		@list($password, $uid) = explode("\t", authcode($_SCOOKIE['auth'], 'DECODE'));
		$_SGLOBAL['supe_uid'] = intval($uid);

		if($password && $_SGLOBAL['supe_uid']) {
			$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('session')." WHERE uid='$_SGLOBAL[supe_uid]'");
			if($member = $_SGLOBAL['db']->fetch_array($query)) {
				if($member['password'] == $password) {
					$_SGLOBAL['supe_username'] = addslashes($member['username']);
					$_SGLOBAL['session'] = $member;
					$_SGLOBAL['name'] = $member['name'];
				} else {
					$_SGLOBAL['supe_uid'] = 0;
				}
			} else {
				$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('member')." WHERE uid='$_SGLOBAL[supe_uid]'");
				if($member = $_SGLOBAL['db']->fetch_array($query)) {
					if($member['password'] == $password) {
						$_SGLOBAL['supe_username'] = addslashes($member['username']);
						$_SGLOBAL['name'] = addslashes($member['name']);
						$session = array('uid' => $_SGLOBAL['supe_uid'], 'username' => $_SGLOBAL['supe_username'], 'password' => $password,'name'=>$_SGLOBAL['name']);
						include_once(S_ROOT.'./source/function_space.php');
						insertsession($session);//登录
					} else {
						$_SGLOBAL['supe_uid'] = 0;
					}
				} else {
					$_SGLOBAL['supe_uid'] = 0;
				}
			}
		}
	}
	if(empty($_SGLOBAL['supe_uid'])) {
		clearcookie();
	} else {
		$_SGLOBAL['username'] = $member['username'];
		$_SGLOBAL['name'] = $member['name'];
		realname_set($_SGLOBAL['supe_uid'],$_SGLOBAL['name'] );
		realname_get();
	}
	if(D_BUG){
			debugOutput('supe_uid',$_SGLOBAL['supe_uid']);
			debugOutput('supe_username',$_SGLOBAL['supe_username']);
			debugOutput('username',$_SGLOBAL['username']);
	}
}

//获取用户app列表
function getuserapp() {
	global $_SGLOBAL, $_SCONFIG;

	$_SGLOBAL['my_userapp'] = $_SGLOBAL['my_menu'] = array();
	$_SGLOBAL['my_menu_more'] = 0;

	if($_SGLOBAL['supe_uid'] && $_SCONFIG['my_status']) {
		$space = getspace($_SGLOBAL['supe_uid']);
		$showcount=0;
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('userapp')." WHERE uid='$_SGLOBAL[supe_uid]' ORDER BY menuorder DESC", 'SILENT');
		while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			$_SGLOBAL['my_userapp'][$value['appid']] = $value;
			if($value['allowsidenav'] && !isset($_SGLOBAL['userapp'][$value['appid']])) {
				if($space['menunum'] < 5) $space['menunum'] = 10;
				if($space['menunum'] > 100 || $showcount < $space['menunum']) {
					$_SGLOBAL['my_menu'][] = $value;
					$showcount++;
				} else {
					$_SGLOBAL['my_menu_more'] = 1;
				}
			}
		}
	}
}

//获取到表名
function tname($name) {
	global $_SC;
	return $_SC['tablepre'].$name;
}

//对话框
function showmessage($msgkey, $url_forward='', $second=1, $values=array()) {
	global $_SGLOBAL, $_SC, $_SCONFIG, $_TPL, $space, $_SN;

	obclean();

	//去掉广告
	$_SGLOBAL['ad'] = array();
	//优先处理client端的信息
	if(!empty($_SGLOBAL['client'])) //来自client端
	{
		//exitwithtip($msgkey);
		$message='<?xml version="1.0" encoding="utf-8"?>';
		$message =$message.'<status '.$msgkey.'>';
		$message =$message.'</status>';
		echo $message;
		ob_out();
		exit();
		//下面的不会运行了
	}
	//语言
	include_once(S_ROOT.'./language/lang_showmessage.php');
	if(isset($_SGLOBAL['msglang'][$msgkey])) {
		$message = lang_replace($_SGLOBAL['msglang'][$msgkey], $values);
	} else {
		$message = $msgkey;
	}
	//手机
	if($_SGLOBAL['mobile']) {
		include template('showmessage');
		exit();
	}
	//显示
	if(empty($_SGLOBAL['inajax']) && $url_forward && empty($second)) {
		header("HTTP/1.1 301 Moved Permanently");
		header("Location: $url_forward");
	} else {
		if($_SGLOBAL['inajax']) {
			if($url_forward) {
				$message = "<a href=\"$url_forward\">$message</a><ajaxok>";
			}
			//$message = "<h1>".$_SGLOBAL['msglang']['box_title']."</h1><a href=\"javascript:;\" onclick=\"hideMenu();\" class=\"float_del\">X</a><div class=\"popupmenu_inner\">$message</div>";
			echo $message;
			ob_out();
		} else {
			if($url_forward) {
				$message = "<a href=\"$url_forward\">$message</a><script>setTimeout(\"window.location.href ='$url_forward';\", ".($second*1000).");</script>";
			}
			include template('showmessage');
		}
	}
	exit();
}

//判断提交是否正确
function submitcheck($var) {
	global $_SGLOBAL;
	if(!empty($_POST[$var]) && $_SERVER['REQUEST_METHOD'] == 'POST') {
		if(!empty($_SGLOBAL['client'])) return true;
		if((empty($_SERVER['HTTP_REFERER']) || preg_replace("/https?:\/\/([^\:\/]+).*/i", "\\1", $_SERVER['HTTP_REFERER']) == preg_replace("/([^\:]+).*/", "\\1", $_SERVER['HTTP_HOST'])) && $_POST['formhash'] == formhash()) {
			return true;
		} else {
			showmessage('submit_invalid');
		}
	} else {
		return false;
	}
}

//添加数据
function inserttable($tablename, $insertsqlarr, $returnid=0, $replace = false, $silent=0) {
	global $_SGLOBAL;

	$insertkeysql = $insertvaluesql = $comma = '';
	foreach ($insertsqlarr as $insert_key => $insert_value) {
		$insertkeysql .= $comma.'`'.$insert_key.'`';
		$insertvaluesql .= $comma.'\''.$insert_value.'\'';
		$comma = ', ';
	}
	$method = $replace?'REPLACE':'INSERT';
	$_SGLOBAL['db']->query($method.' INTO '.tname($tablename).' ('.$insertkeysql.') VALUES ('.$insertvaluesql.')', $silent?'SILENT':'');
	if($returnid && !$replace) {
		return $_SGLOBAL['db']->insert_id();
	}
}

//更新数据
function updatetable($tablename, $setsqlarr, $wheresqlarr, $silent=0) {
	global $_SGLOBAL;

	$setsql = $comma = '';
	foreach ($setsqlarr as $set_key => $set_value) {
		if(is_array($set_value)) {
			$setsql .= $comma.'`'.$set_key.'`'.'='.$set_value[0];
		} else {
			$setsql .= $comma.'`'.$set_key.'`'.'=\''.$set_value.'\'';
		}
		$comma = ', ';
	}
	$where = $comma = '';
	if(empty($wheresqlarr)) {
		$where = '1';
	} elseif(is_array($wheresqlarr)) {
		foreach ($wheresqlarr as $key => $value) {
			$where .= $comma.'`'.$key.'`'.'=\''.$value.'\'';
			$comma = ' AND ';
		}
	} else {
		$where = $wheresqlarr;
	}
	$_SGLOBAL['db']->query('UPDATE '.tname($tablename).' SET '.$setsql.' WHERE '.$where, $silent?'SILENT':'');
}

//获取用户空间信息
function getspace($key, $indextype='uid', $auto_open=0) {
	global $_SGLOBAL, $_SCONFIG, $_SN;

	$var = "space_{$key}_{$indextype}";
	if(empty($_SGLOBAL[$var])) {
		$space = array();
		$query = $_SGLOBAL['db']->query("SELECT sf.*, s.* FROM ".tname('space')." s LEFT JOIN ".tname('spacefield')." sf ON sf.uid=s.uid WHERE s.{$indextype}='$key'");
		if(!$space = $_SGLOBAL['db']->fetch_array($query)) {
			$space = array();
			if($indextype=='uid' && $auto_open) {
				//自动开通空间
				include_once(S_ROOT.'./uc_client/client.php');
				if($user = uc_get_user($key, 1)) {
					include_once(S_ROOT.'./source/function_space.php');
					$space = space_open($user[0], addslashes($user[1]), 0, addslashes($user[2]));
				}
			}
		}
		if($space) {			
			//$_SN[$space['uid']] = ($_SCONFIG['realname'] && $space['name'] && $space['namestatus'])?$space['name']:$space['username'];
			$_SN[$space['uid']] = $space['name'];
			$space['self'] = ($space['uid']==$_SGLOBAL['supe_uid'])?1:0;

			//好友缓存
			$space['friends'] = array();
			if(empty($space['friend'])) {
				if($space['friendnum']>0) {
					$fstr = $fmod = '';
					$query = $_SGLOBAL['db']->query("SELECT fuid FROM ".tname('friend')." WHERE uid='$space[uid]' AND status='1'");
					while ($value = $_SGLOBAL['db']->fetch_array($query)) {
						$space['friends'][] = $value['fuid'];
						$fstr .= $fmod.$value['fuid'];
						$fmod = ',';
					}
					$space['friend'] = $fstr;
				}
			} else {
				$space['friends'] = explode(',', $space['friend']);
			}

			$space['username'] = addslashes($space['username']);
			$space['name'] = addslashes($space['name']);
			$space['privacy'] = empty($space['privacy'])?(empty($_SCONFIG['privacy'])?array():$_SCONFIG['privacy']):unserialize($space['privacy']);

			//通知数
			$space['allnotenum'] = 0;
			foreach (array('notenum','pokenum','addfriendnum','mtaginvitenum','eventinvitenum','myinvitenum') as $value) {
				$space['allnotenum'] = $space['allnotenum'] + $space[$value];
			}
			if($space['self']) {
				$_SGLOBAL['member'] = $space;
			}
		}
		$_SGLOBAL[$var] = $space;
	}
	return $_SGLOBAL[$var];
}

//获得用户UID
function getuid($name) {
	global $_SGLOBAL, $_SCONFIG;

	$wherearr[] = "(username='$name')";
	if($_SCONFIG['realname']) {
		$wherearr[] = "(name='$name' AND namestatus = 1)";
	}
	$uid = 0;
	$query = $_SGLOBAL['db']->query("SELECT uid,username,name,namestatus FROM ".tname('space')." WHERE ".implode(' OR ', $wherearr)." LIMIT 1");
	if($space = $_SGLOBAL['db']->fetch_array($query)) {
		$uid = $space['uid'];
	}
	return $uid;
}

//获取当前用户信息
function getmember() {
	global $_SGLOBAL, $space;

	if(empty($_SGLOBAL['member']) && $_SGLOBAL['supe_uid']) {
		if($space['uid'] == $_SGLOBAL['supe_uid']) {
			$_SGLOBAL['member'] = $space;
		} else {
			$_SGLOBAL['member'] = getspace($_SGLOBAL['supe_uid']);
		}
	}
}

//检查隐私
function ckprivacy($type, $feedmode=0) {
	global $_SGLOBAL, $space, $_SCONFIG;

	$var = "ckprivacy_{$type}_{$feedmode}";
	if(isset($_SGLOBAL[$var])) {
		return $_SGLOBAL[$var];
	}
	$result = false;
	if($feedmode) {
		if($type == 'spaceopen') {
			if(!empty($_SCONFIG['privacy']['feed'][$type])) {
				$result = true;
			}
		} elseif(!empty($space['privacy']['feed'][$type])) {
			$result = true;
		}
	} elseif($space['self']){
		//自己
		$result = true;
	} else {
		if(empty($space['privacy']['view'][$type])) {
			$result = true;
		}
		if(!$result && $space['privacy']['view'][$type] == 1) {
			//是否好友
			if(!isset($space['isfriend'])) {
				$space['isfriend'] = $space['self'];
				if($space['friends'] && in_array($_SGLOBAL['supe_uid'], $space['friends'])) {
					$space['isfriend'] = 1;//是好友
				}
			}
			if($space['isfriend']) {
				$result = true;
			}
		}
	}
	$_SGLOBAL[$var] = $result;//当前页面缓存
	return $result;
}

//检查APP隐私
function app_ckprivacy($privacy) {
	global $_SGLOBAL, $space;

	$var = "app_ckprivacy_{$privacy}";
	if(isset($_SGLOBAL[$var])) {
		return $_SGLOBAL[$var];
	}
	$result = false;
	switch ($privacy) {
		case 0://公开
			$result = true;
			break;
		case 1://好友
			if(!isset($space['isfriend'])) {
				$space['isfriend'] = $space['self'];
				if($space['friends'] && in_array($_SGLOBAL['supe_uid'], $space['friends'])) {
					$space['isfriend'] = 1;//是好友
				}
			}
			if($space['isfriend']) {
				$result = true;
			}
			break;
		case 2://部分好友
			break;
		case 3://自己
			if($space['self']) {
				$result = true;
			}
			break;
		case 4://加密
			break;
		case 5://没有人
			break;
		default:
			$result = true;
			break;
	}
	$_SGLOBAL[$var] = $result;
	return $result;
}

//获取用户组
function getgroupid($experience, $gid=0) {
	global $_SGLOBAL;

	$needfind = false;
	if($gid) {
		if(@include_once(S_ROOT.'./data/data_usergroup_'.$gid.'.php')) {
			$group = $_SGLOBAL['usergroup'][$gid];
			if(empty($group['system'])) {
				if($group['exphigher']<$experience || $group['explower']>$experience) {
					$needfind = true;
				}
			}
		}
	} else {
		$needfind = true;
	}
	if($needfind) {
		$query = $_SGLOBAL['db']->query("SELECT gid FROM ".tname('usergroup')." WHERE explower<='$experience' AND system='0' ORDER BY explower DESC LIMIT 1");
		$gid = $_SGLOBAL['db']->result($query, 0);
	}
	return $gid;
}

//检查权限
function checkperm($permtype) {
	global $_SGLOBAL, $space;

	if($permtype == 'admin') $permtype = 'manageconfig';

	$var = 'checkperm_'.$permtype;
	if(!isset($_SGLOBAL[$var])) {
		if(empty($_SGLOBAL['supe_uid'])) {
			$_SGLOBAL[$var] = '';
		} else {
			if(empty($_SGLOBAL['member'])) getmember();
			$gid = getgroupid($_SGLOBAL['member']['experience'], $_SGLOBAL['member']['groupid']);
			@include_once(S_ROOT.'./data/data_usergroup_'.$gid.'.php');

			if($gid != $_SGLOBAL['member']['groupid']) {
				updatetable('space', array('groupid'=>$gid), array('uid'=>$_SGLOBAL['supe_uid']));
				//赠送道具
				if($_SGLOBAL['usergroup'][$gid]['magicaward']) {
					include_once(S_ROOT.'./source/inc_magicaward.php');
				}
			}
			
			$_SGLOBAL[$var] = empty($_SGLOBAL['usergroup'][$gid][$permtype])?'':$_SGLOBAL['usergroup'][$gid][$permtype];
			if(substr($permtype, 0, 6) == 'manage' && empty($_SGLOBAL[$var])) {
				$_SGLOBAL[$var] = $_SGLOBAL['usergroup'][$gid]['manageconfig'];//权限覆盖
				if(empty($_SGLOBAL[$var])) {
					$_SGLOBAL[$var] = ckfounder($_SGLOBAL['supe_uid'])?1:0;//创始人
				}
			}
		}
	}
	return $_SGLOBAL[$var];
}

//写运行日志
function runlog($file, $log, $halt=0) {
	global $_SGLOBAL, $_SERVER;

	$nowurl = $_SERVER['REQUEST_URI']?$_SERVER['REQUEST_URI']:($_SERVER['PHP_SELF']?$_SERVER['PHP_SELF']:$_SERVER['SCRIPT_NAME']);
	$log = sgmdate('Y-m-d H:i:s', $_SGLOBAL['timestamp'])."\t$type\t".getonlineip()."\t$_SGLOBAL[supe_uid]\t{$nowurl}\t".str_replace(array("\r", "\n"), array(' ', ' '), trim($log))."\n";
	$yearmonth = sgmdate('Ym', $_SGLOBAL['timestamp']);
	$logdir = './data/log/';
	if(!is_dir($logdir)) mkdir($logdir, 0777);
	$logfile = $logdir.$yearmonth.'_'.$file.'.php';
	if(@filesize($logfile) > 2048000) {
		$dir = opendir($logdir);
		$length = strlen($file);
		$maxid = $id = 0;
		while($entry = readdir($dir)) {
			if(strexists($entry, $yearmonth.'_'.$file)) {
				$id = intval(substr($entry, $length + 8, -4));
				$id > $maxid && $maxid = $id;
			}
		}
		closedir($dir);
		$logfilebak = $logdir.$yearmonth.'_'.$file.'_'.($maxid + 1).'.php';
		@rename($logfile, $logfilebak);
	}
	if($fp = @fopen($logfile, 'a')) {
		@flock($fp, 2);
		fwrite($fp, "<?PHP exit;?>\t".str_replace(array('<?', '?>', "\r", "\n"), '', $log)."\n");
		fclose($fp);
	}
	if($halt) exit();
}

//获取字符串
function getstr($string, $length, $in_slashes=0, $out_slashes=0, $censor=0, $bbcode=0, $html=0) {
	global $_SC, $_SGLOBAL;
	if(empty($_SGLOBAL['client']))
		$string = trim($string);

		if($in_slashes) {
		//传入的字符有slashes
		$string = sstripslashes($string);
	}
	if($html < 0) {
		//去掉html标签
		$string = preg_replace("/(\<[^\<]*\>|\r|\n|\s|\[.+?\])/is", ' ', $string);
		$string = shtmlspecialchars($string);
	} elseif ($html == 0) {
		//转换html标签
		$string = shtmlspecialchars($string);
	}
	if($censor) {
		//词语屏蔽
		@include_once(S_ROOT.'./data/data_censor.php');
		if($_SGLOBAL['censor']['banned'] && preg_match($_SGLOBAL['censor']['banned'], $string)) {
			showmessage('information_contains_the_shielding_text');
		} else {
			$string = empty($_SGLOBAL['censor']['filter']) ? $string :
				@preg_replace($_SGLOBAL['censor']['filter']['find'], $_SGLOBAL['censor']['filter']['replace'], $string);
		}
	}
	if($length && strlen($string) > $length) {
		//截断字符
		$wordscut = '';
		if(strtolower($_SC['charset']) == 'utf-8') {
			//utf8编码
			$n = 0;
			$tn = 0;
			$noc = 0;
			while ($n < strlen($string)) {
				$t = ord($string[$n]);
				if($t == 9 || $t == 10 || (32 <= $t && $t <= 126)) {
					$tn = 1;
					$n++;
					$noc++;
				} elseif(194 <= $t && $t <= 223) {
					$tn = 2;
					$n += 2;
					$noc += 2;
				} elseif(224 <= $t && $t < 239) {
					$tn = 3;
					$n += 3;
					$noc += 2;
				} elseif(240 <= $t && $t <= 247) {
					$tn = 4;
					$n += 4;
					$noc += 2;
				} elseif(248 <= $t && $t <= 251) {
					$tn = 5;
					$n += 5;
					$noc += 2;
				} elseif($t == 252 || $t == 253) {
					$tn = 6;
					$n += 6;
					$noc += 2;
				} else {
					$n++;
				}
				if ($noc >= $length) {
					break;
				}
			}
			if ($noc > $length) {
				$n -= $tn;
			}
			$wordscut = substr($string, 0, $n);
		} else {
			for($i = 0; $i < $length - 1; $i++) {
				if(ord($string[$i]) > 127) {
					$wordscut .= $string[$i].$string[$i + 1];
					$i++;
				} else {
					$wordscut .= $string[$i];
				}
			}
		}
		$string = $wordscut;
	}
	if($bbcode) {
		include_once(S_ROOT.'./source/function_bbcode.php');
		$string = bbcode($string, $bbcode);
	}
	if($out_slashes) {
		$string = saddslashes($string);
	}
	if(empty($_SGLOBAL['client']))
		return trim($string);
	else
		return $string;
}

//时间格式化
function sgmdate($dateformat, $timestamp='', $format=0) {
	global $_SCONFIG, $_SGLOBAL;
	if(empty($timestamp)) {
		$timestamp = $_SGLOBAL['timestamp'];
	}
	$timeoffset = strlen($_SGLOBAL['member']['timeoffset'])>0?intval($_SGLOBAL['member']['timeoffset']):intval($_SCONFIG['timeoffset']);
	$result = '';
	if($format) {
		$time = $_SGLOBAL['timestamp'] - $timestamp;
		if($time > 24*3600) {
			$result = gmdate($dateformat, $timestamp + $timeoffset * 3600);
		} elseif ($time > 3600) {
			$result = intval($time/3600).lang('hour').lang('before');
		} elseif ($time > 60) {
			$result = intval($time/60).lang('minute').lang('before');
		} elseif ($time > 0) {
			$result = $time.lang('second').lang('before');
		} else {
			$result = lang('now');
		}
	} else {
		$result = gmdate($dateformat, $timestamp + $timeoffset * 3600);
	}
	return $result;
}

//字符串时间化
function sstrtotime($string) {
	global $_SGLOBAL, $_SCONFIG;
	$time = '';
	if($string) {
		$time = strtotime($string);
		if(gmdate('H:i', $_SGLOBAL['timestamp'] + $_SCONFIG['timeoffset'] * 3600) != date('H:i', $_SGLOBAL['timestamp'])) {
			$time = $time - $_SCONFIG['timeoffset'] * 3600;
		}
	}
	return $time;
}

//分页
function multi($num, $perpage, $curpage, $mpurl, $ajaxdiv='', $todiv='',$ajax=0) {
	global $_SCONFIG, $_SGLOBAL;
	if($curpage==0)
			$curpage=1;
	$inajax=$_SGLOBAL['inajax'];
	$_SGLOBAL['inajax']=empty($_SGLOBAL['inajax'])?$ajax:$_SGLOBAL['inajax'];
	if(empty($ajaxdiv) && $_SGLOBAL['inajax']) {
		$ajaxdiv = $_GET['ajaxdiv'];
	}

	$page = 5;
	if($_SGLOBAL['showpage']) $page = $_SGLOBAL['showpage'];

	$multipage = '';
	$mpurl .= strpos($mpurl, '?') ? '&' : '?';
	$realpages = 1;
	if($num > $perpage) {
		$offset = 2;
		$realpages = @ceil($num / $perpage);
		$pages = $_SCONFIG['maxpage'] && $_SCONFIG['maxpage'] < $realpages ? $_SCONFIG['maxpage'] : $realpages;
		if($page > $pages) {
			$from = 1;
			$to = $pages;
		} else {
			$from = $curpage - $offset;
			$to = $from + $page - 1;
			if($from < 1) {
				$to = $curpage + 1 - $from;
				$from = 1;
				if($to - $from < $page) {
					$to = $page;
				}
			} elseif($to > $pages) {
				$from = $pages - $page + 1;
				$to = $pages;
			}
		}
		$multipage = '';
		$urlplus = $todiv?"#$todiv":'';
		if($curpage - $offset > 1 && $pages > $page) {
			$multipage .= "<a ";
			if($_SGLOBAL['inajax']) {
				$multipage .= "href=\"javascript:;\" onclick=\"ajaxget('{$mpurl}page=1&ajaxdiv=$ajaxdiv', '$ajaxdiv')\"";
			} else {
				$multipage .= "href=\"{$mpurl}page=1{$urlplus}\"";
			}
			$multipage .= " class=\"first\">1 ...</a>";
		}
		if($curpage > 1) {
			$multipage .= "<a ";
			if($_SGLOBAL['inajax']) {
				$multipage .= "href=\"javascript:;\" onclick=\"ajaxget('{$mpurl}page=".($curpage-1)."&ajaxdiv=$ajaxdiv', '$ajaxdiv')\"";
			} else {
				$multipage .= "href=\"{$mpurl}page=".($curpage-1)."$urlplus\"";
			}
			$multipage .= " class=\"prev\">前一页</a>";
		}
		for($i = $from; $i <= $to; $i++) {
			if($i == $curpage) {
				$multipage .= '<strong>'.$i.'</strong>';
			} else {
				$multipage .= "<a ";
				if($_SGLOBAL['inajax']) {
					$multipage .= "href=\"javascript:;\" onclick=\"ajaxget('{$mpurl}page=$i&ajaxdiv=$ajaxdiv', '$ajaxdiv')\"";
				} else {
					$multipage .= "href=\"{$mpurl}page=$i{$urlplus}\"";
				}
				$multipage .= ">$i</a>";
			}
		}
		if($curpage < $pages) {
			$multipage .= "<a ";
			if($_SGLOBAL['inajax']) {
				$multipage .= "href=\"javascript:;\" onclick=\"ajaxget('{$mpurl}page=".($curpage+1)."&ajaxdiv=$ajaxdiv', '$ajaxdiv')\"";
			} else {
				$multipage .= "href=\"{$mpurl}page=".($curpage+1)."{$urlplus}\"";
			}
			$multipage .= " class=\"next\">后一页</a>";
		}
		if($to < $pages) {
			$multipage .= "<a ";
			if($_SGLOBAL['inajax']) {
				$multipage .= "href=\"javascript:;\" onclick=\"ajaxget('{$mpurl}page=$pages&ajaxdiv=$ajaxdiv', '$ajaxdiv')\"";
			} else {
				$multipage .= "href=\"{$mpurl}page=$pages{$urlplus}\"";
			}
			$multipage .= " class=\"last\">... $realpages</a>";
		}
		if($multipage) {
			//$multipage = '<em>&nbsp;'.$num.'&nbsp;</em>'.$multipage;
			$totalpages = ceil($num/$perpage);
			$multipage = '<em>&nbsp;共'.$totalpages.'页&nbsp;</em>'.$multipage;

		}
	}
	$_SGLOBAL['inajax']=$inajax;
	return $multipage;
}


//处理分页
function smulti($start, $perpage, $count, $url, $ajaxdiv='') {
	global $_SGLOBAL;

	$multi = array('last'=>-1, 'next'=>-1, 'begin'=>-1, 'end'=>-1, 'html'=>'');
	if($start > 0) {
		if(empty($count)) {
			showmessage('no_data_pages');
		} else {
			$multi['last'] = $start - $perpage;
		}
	}

	$showhtml = 0;
	if($count == $perpage) {
		$multi['next'] = $start + $perpage;
	}
	$multi['begin'] = $start + 1;
	$multi['end'] = $start + $count;

	if($multi['begin'] >= 0) {
		if($multi['last'] >= 0) {
			$showhtml = 1;
			if($_SGLOBAL['inajax']) {
				$multi['html'] .= "<a href=\"javascript:;\" onclick=\"ajaxget('$url&ajaxdiv=$ajaxdiv', '$ajaxdiv')\">|&lt;</a> <a href=\"javascript:;\" onclick=\"ajaxget('$url&start=$multi[last]&ajaxdiv=$ajaxdiv', '$ajaxdiv')\">&lt;</a> ";
			} else {
				$multi['html'] .= "<a href=\"$url\">|&lt;</a> <a href=\"$url&start=$multi[last]\">&lt;</a> ";
			}
		} else {
			$multi['html'] .= "&lt;";
		}
		$multi['html'] .= " $multi[begin]~$multi[end] ";
		if($multi['next'] >= 0) {
			$showhtml = 1;
			if($_SGLOBAL['inajax']) {
				$multi['html'] .= " <a href=\"javascript:;\" onclick=\"ajaxget('$url&start=$multi[next]&ajaxdiv=$ajaxdiv', '$ajaxdiv')\">&gt;</a> ";
			} else {
				$multi['html'] .= " <a href=\"$url&start=$multi[next]\">&gt;</a>";
			}
		} else {
			$multi['html'] .= " &gt;";
		}
	}

	return $showhtml?$multi['html']:'';
}

//ob
function obclean() {
	global $_SC;

	ob_end_clean();
	if ($_SC['gzipcompress'] && function_exists('ob_gzhandler')) {
		ob_start('ob_gzhandler');
	} else {
		ob_start();
	}
}

//模板调用
function template($name) {
	global $_SCONFIG, $_SGLOBAL;

	if($_SGLOBAL['mobile']) {
		$objfile = S_ROOT.'./api/mobile/tpl_'.$name.'.php';
		if (!file_exists($objfile)) {
			showmessage('该功能wap版暂不可用，您可以到电脑上查看或用手机查看完整版');
		}
	} else {
		if(strexists($name,'/')) {
			$tpl = $name;
		} else {
			$tpl = "template/$_SCONFIG[template]/$name";
		}
		$objfile = S_ROOT.'./data/tpl_cache/'.str_replace('/','_',$tpl).'.php';
		if(TEMPLATE_CACHE_UPDATE||!file_exists($objfile)) {
			include_once(S_ROOT.'./source/function_template.php');
			parse_template($tpl);
		}
	}
	return $objfile;
}

//子模板更新检查
function subtplcheck($subfiles, $mktime, $tpl) {
	global $_SC, $_SCONFIG;

	if($_SC['tplrefresh'] && ($_SC['tplrefresh'] == 1 || mt_rand(1, $_SC['tplrefresh']) == 1)) {
		$subfiles = explode('|', $subfiles);
		foreach ($subfiles as $subfile) {
			$tplfile = S_ROOT.'./'.$subfile.'.htm';
			if(!file_exists($tplfile)) {
				$tplfile = str_replace('/'.$_SCONFIG['template'].'/', '/default/', $tplfile);
			}
			@$submktime = filemtime($tplfile);
			if($submktime > $mktime) {
				include_once(S_ROOT.'./source/function_template.php');
				parse_template($tpl);
				break;
			}
		}
	}
}

//模块
function block($param) {
	global $_SBLOCK;

	include_once(S_ROOT.'./source/function_block.php');
	block_batch($param);
}

//获取数目
function getcount($tablename, $wherearr=array(), $get='COUNT(*)') {
	global $_SGLOBAL;
	if(empty($wherearr)) {
		$wheresql = '1';
	} else {
		$wheresql = $mod = '';
		foreach ($wherearr as $key => $value) {
			$wheresql .= $mod."`$key`='$value'";
			$mod = ' AND ';
		}
	}
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT $get FROM ".tname($tablename)." WHERE $wheresql LIMIT 1"), 0);
}

//调整输出
function ob_out() {
	global $_SGLOBAL, $_SCONFIG, $_SC;

	$content = ob_get_contents();

	$preg_searchs = $preg_replaces = $str_searchs = $str_replaces = array();

	if($_SCONFIG['allowrewrite']) {
		$preg_searchs[] = "/\<a href\=\"space\.php\?(uid|do)+\=([a-z0-9\=\&]+?)\"/ie";
		$preg_searchs[] = "/\<a href\=\"space.php\"/i";
		$preg_searchs[] = "/\<a href\=\"network\.php\?ac\=([a-z0-9\=\&]+?)\"/ie";
		$preg_searchs[] = "/\<a href\=\"network.php\"/i";

		$preg_replaces[] = 'rewrite_url(\'space-\',\'\\2\')';
		$preg_replaces[] = '<a href="space.html"';
		$preg_replaces[] = 'rewrite_url(\'network-\',\'\\1\')';
		$preg_replaces[] = '<a href="network.html"';
	}
	if($_SCONFIG['linkguide']) {
		$preg_searchs[] = "/\<a href\=\"http\:\/\/(.+?)\"/ie";
		$preg_replaces[] = 'iframe_url(\'\\1\')';
	}

	if($_SGLOBAL['inajax']) {
		$preg_searchs[] = "/([\x01-\x09\x0b-\x0c\x0e-\x1f])+/";
		$preg_replaces[] = ' ';

		$str_searchs[] = ']]>';
		$str_replaces[] = ']]&gt;';
	}

	if($preg_searchs) {
		$content = preg_replace($preg_searchs, $preg_replaces, $content);
	}
	if($str_searchs) {
		$content = trim(str_replace($str_searchs, $str_replaces, $content));
	}

	obclean();
	if($_SGLOBAL['inajax']) {
		xml_out($content);
	} else{
		if($_SCONFIG['headercharset']) {
			@header('Content-Type: text/html; charset='.$_SC['charset']);
		}
		echo $content;
		if(D_BUG) {
			@include_once(S_ROOT.'./source/inc_debug.php');
		}
	}
}

function xml_out($content) {
	global $_SC;
	@header("Expires: -1");
	@header("Cache-Control: no-store, private, post-check=0, pre-check=0, max-age=0", FALSE);
	@header("Pragma: no-cache");
	@header("Content-type: application/xml; charset=$_SC[charset]");
	echo '<'."?xml version=\"1.0\" encoding=\"$_SC[charset]\"?>\n";
	echo "<root><![CDATA[".trim($content)."]]></root>";
	exit();
}

//rewrite链接
function rewrite_url($pre, $para) {
	$para = str_replace(array('&','='), array('-', '-'), $para);
	return '<a href="'.$pre.$para.'.html"';
}

//外链
function iframe_url($url) {
	$url = rawurlencode($url);
	return "<a href=\"link.php?url=http://$url\"";
}

//处理搜索关键字
function stripsearchkey($string) {
	$string = trim($string);
	$string = str_replace('*', '%', addcslashes($string, '%_'));
	$string = str_replace('_', '\_', $string);
	return $string;
}

//检查搜索
function cksearch($theurl) {
	global $_SGLOBAL, $_SCONFIG, $space;
	
	$theurl = stripslashes($theurl)."&page=".$_GET['page'];
	if($searchinterval = checkperm('searchinterval')) {
		$waittime = $searchinterval - ($_SGLOBAL['timestamp'] - $space['lastsearch']);
		if($waittime > 0) {
			showmessage('search_short_interval', '', 1, array($waittime, $theurl));
		}
	}
	if(!checkperm('searchignore')) {
		$reward = getreward('search', 0);
		if($reward['credit'] || $reward['experience']) {
			if(empty($_GET['confirm'])) {
				$theurl .= '&confirm=yes';
				showmessage('points_deducted_yes_or_no', '', 1, array($reward['credit'], $reward['experience'], $theurl));
			} else {
				if($space['credit'] < $reward['credit'] || $space['experience'] < $reward['experience']) {
					showmessage('points_search_error');
				} else {
					//扣分
					$_SGLOBAL['db']->query("UPDATE ".tname('space')." SET lastsearch='$_SGLOBAL[timestamp]', credit=credit-$reward[credit], experience=experience-$reward[experience] WHERE uid='$_SGLOBAL[supe_uid]'");
				}
			}
		}
	}
}

//是否屏蔽二级域名
function isholddomain($domain) {
	global $_SCONFIG;

	$domain = strtolower($domain);

	if(preg_match("/^[^a-z]/i", $domain)) return true;
	$holdmainarr = empty($_SCONFIG['holddomain'])?array('www'):explode('|', $_SCONFIG['holddomain']);
	$ishold = false;
	foreach ($holdmainarr as $value) {
		if(strpos($value, '*') === false) {
			if(strtolower($value) == $domain) {
				$ishold = true;
				break;
			}
		} else {
			$value = str_replace('*', '', $value);
			if(@preg_match("/$value/i", $domain)) {
				$ishold = true;
				break;
			}
		}
	}
	return $ishold;
}

//连接字符
function simplode($ids) {
	return "'".implode("','", $ids)."'";
}

//显示进程处理时间
function debuginfo() {
	global $_SGLOBAL, $_SC, $_SCONFIG;

	if(empty($_SCONFIG['debuginfo'])) {
		$info = '';
	} else {
		$mtime = explode(' ', microtime());
		$totaltime = number_format(($mtime[1] + $mtime[0] - $_SGLOBAL['supe_starttime']), 4);
		$info = 'Processed in '.$totaltime.' second(s), '.$_SGLOBAL['db']->querynum.' queries'.
				($_SC['gzipcompress'] ? ', Gzip enabled' : NULL);
	}

	return $info;
}

//格式化大小函数
function formatsize($size) {
	$prec=3;
	$size = round(abs($size));
	$units = array(0=>" B ", 1=>" KB", 2=>" MB", 3=>" GB", 4=>" TB");
	if ($size==0) return str_repeat(" ", $prec)."0$units[0]";
	$unit = min(4, floor(log($size)/log(2)/10));
	$size = $size * pow(2, -10*$unit);
	$digi = $prec - 1 - floor(log($size)/log(10));
	$size = round($size * pow(10, $digi)) * pow(10, -$digi);
	return $size.$units[$unit];
}

//获取文件内容
function sreadfile($filename) {
	$content = '';
	if(function_exists('file_get_contents')) {
		@$content = file_get_contents($filename);
	} else {
		if(@$fp = fopen($filename, 'r')) {
			@$content = fread($fp, filesize($filename));
			@fclose($fp);
		}
	}
	return $content;
}

//写入文件
function swritefile($filename, $writetext, $openmod='w') {
	if(@$fp = fopen($filename, $openmod)) {
		flock($fp, 2);
		fwrite($fp, $writetext);
		fclose($fp);
		return true;
	} else {
		runlog('error', "File: $filename write error.");
		return false;
	}
}

//产生随机字符
function random($length, $numeric = 0) {
	PHP_VERSION < '4.2.0' ? mt_srand((double)microtime() * 1000000) : mt_srand();
	$seed = base_convert(md5(print_r($_SERVER, 1).microtime()), 16, $numeric ? 10 : 35);
	$seed = $numeric ? (str_replace('0', '', $seed).'012340567890') : ($seed.'zZ'.strtoupper($seed));
	$hash = '';
	$max = strlen($seed) - 1;
	for($i = 0; $i < $length; $i++) {
		$hash .= $seed[mt_rand(0, $max)];
	}
	return $hash;
}

//判断字符串是否存在
function strexists($haystack, $needle) {
	return !(strpos($haystack, $needle) === FALSE);
}

//获取数据
function data_get($var, $isarray=0) {
	global $_SGLOBAL;

	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('data')." WHERE var='$var' LIMIT 1");
	if($value = $_SGLOBAL['db']->fetch_array($query)) {
		return $isarray?$value:$value['datavalue'];
	} else {
		return '';
	}
}

//更新数据
function data_set($var, $datavalue, $clean=0) {
	global $_SGLOBAL;

	if($clean) {
		$_SGLOBAL['db']->query("DELETE FROM ".tname('data')." WHERE var='$var'");
	} else {
		if(is_array($datavalue)) $datavalue = serialize(sstripslashes($datavalue));
		$_SGLOBAL['db']->query("REPLACE INTO ".tname('data')." (var, datavalue, dateline) VALUES ('$var', '".addslashes($datavalue)."', '$_SGLOBAL[timestamp]')");
	}
}

//检查站点是否关闭
function checkclose() {
	global $_SGLOBAL, $_SCONFIG;

	//站点关闭
	if($_SCONFIG['close'] && !ckfounder($_SGLOBAL['supe_uid']) && !checkperm('closeignore')) {
		if(empty($_SCONFIG['closereason'])) {
			showmessage('site_temporarily_closed');
		} else {
			showmessage($_SCONFIG['closereason']);
		}
	}
	//IP访问检查
	if((!ipaccess($_SCONFIG['ipaccess']) || ipbanned($_SCONFIG['ipbanned'])) && !ckfounder($_SGLOBAL['supe_uid']) && !checkperm('closeignore')) {
		showmessage('ip_is_not_allowed_to_visit');
	}
}

//站点链接
function getsiteurl() {
	global $_SCONFIG;

	if(empty($_SCONFIG['siteallurl'])) {
		$uri = $_SERVER['REQUEST_URI']?$_SERVER['REQUEST_URI']:($_SERVER['PHP_SELF']?$_SERVER['PHP_SELF']:$_SERVER['SCRIPT_NAME']);
		return shtmlspecialchars('http://'.$_SERVER['HTTP_HOST'].substr($uri, 0, strrpos($uri, '/')+1));
	} else {
		return $_SCONFIG['siteallurl'];
	}
}

//获取文件名后缀
function fileext($filename) {
	return strtolower(trim(substr(strrchr($filename, '.'), 1)));
}

//去掉slassh
function sstripslashes($string) {
	if(is_array($string)) {
		foreach($string as $key => $val) {
			$string[$key] = sstripslashes($val);
		}
	} else {
		$string = stripslashes($string);
	}
	return $string;
}

//显示广告
function adshow($pagetype) {
	global $_SGLOBAL;

	@include_once(S_ROOT.'./data/data_ad.php');
	if(empty($_SGLOBAL['ad']) || empty($_SGLOBAL['ad'][$pagetype])) return false;
	$ads = $_SGLOBAL['ad'][$pagetype];
	$key = mt_rand(0, count($ads)-1);
	$id = $ads[$key];
	$file = S_ROOT.'./data/adtpl/'.$id.'.htm';
	echo sreadfile($file);
}

//编码转换
function siconv($str, $out_charset, $in_charset='') {
	global $_SC;

	$in_charset = empty($in_charset)?strtoupper($_SC['charset']):strtoupper($in_charset);
	$out_charset = strtoupper($out_charset);
	if($in_charset != $out_charset) {
		if (function_exists('iconv') && (@$outstr = iconv("$in_charset//IGNORE", "$out_charset//IGNORE", $str))) {
			return $outstr;
		} elseif (function_exists('mb_convert_encoding') && (@$outstr = mb_convert_encoding($str, $out_charset, $in_charset))) {
			return $outstr;
		}
	}
	return $str;//转换失败
}

//获取用户数据
function getpassport($username, $password) {
	global $_SGLOBAL, $_SC;

	$passport = array();
	if(!@include_once S_ROOT.'./uc_client/client.php') {
		showmessage('system_error');
	}

	$ucresult = uc_user_login($username, $password);
	if($ucresult[0] > 0) {
		$passport['uid'] = $ucresult[0];
		$passport['username'] = $ucresult[1];
		$passport['email'] = $ucresult[3];
		$passport['name'] = $ucresult[5];
	}
	return $passport;
}

//用户操作时间间隔检查
function interval_check($type) {
	global $_SGLOBAL, $space;

	$intervalname = $type.'interval';
	$lastname = 'last'.$type;

	$waittime = 0;
	if($interval = checkperm($intervalname)) {
		$lasttime = isset($space[$lastname])?$space[$lastname]:getcount('space', array('uid'=>$_SGLOBAL['supe_uid']), $lastname);
		$waittime = $interval - ($_SGLOBAL['timestamp'] - $lasttime);
	}
	return $waittime;
}

//处理上传图片连接
function pic_get($filepath, $thumb, $remote, $return_thumb=1) {
	global $_SCONFIG, $_SC;

	if(empty($filepath)) {
		$url = 'image/nopic.gif';
	} else {
		$url = $filepath;
		if($return_thumb && $thumb) $url .= '.thumb.jpg';
		if($remote) {
			$url = $_SCONFIG['ftpurl'].$url;
		} else {
			$url = $_SC['attachurl'].$url;
		}
	}

	return $url;
}

//获得封面图片链接
function pic_cover_get($pic, $picflag) {
	global $_SCONFIG, $_SC;

	if(empty($pic)) {
		$url = 'image/nopic.gif';
	} else {
		if($picflag == 1) {//本地
			$url = $_SC['attachurl'].$pic;
		} elseif ($picflag == 2) {//远程
			$url = $_SCONFIG['ftpurl'].$pic;
		} else {//网络
			$url = $pic;
		}
	}

	return $url;
}

//处理积分星星
function getstar($experience) {
	global $_SCONFIG;

	$starimg = '';
	if($_SCONFIG['starcredit'] > 1) {
		//计算星星数
		$starnum = intval($experience/$_SCONFIG['starcredit']) + 1;
		if($_SCONFIG['starlevelnum'] < 2) {
			if($starnum > 10) $starnum = 10;
			for($i = 0; $i < $starnum; $i++) {
				$starimg .= '<img src="image/star_level10.gif" align="absmiddle" />';
			}
		} else {
			//计算等级(10个)
			for($i = 10; $i > 0; $i--) {
				$numlevel = intval($starnum / pow($_SCONFIG['starlevelnum'], ($i - 1)));
				if($numlevel > 10) $numlevel = 10;
				if($numlevel) {
					for($j = 0; $j < $numlevel; $j++) {
						$starimg .= '<img src="image/star_level'.$i.'.gif" align="absmiddle" />';
					}
					break;
				}
			}
		}
	}
	if(empty($starimg)) $starimg = '<img src="image/credit.gif" alt="'.$experience.'" align="absmiddle" alt="'.$experience.'" title="'.$experience.'" />';
	return $starimg;
}

//获取好友状态
function getfriendstatus($uid, $fuid) {
	global $_SGLOBAL;

	$query = $_SGLOBAL['db']->query("SELECT status FROM ".tname('friend')." WHERE uid='$uid' AND fuid='$fuid' LIMIT 1");
	if($value = $_SGLOBAL['db']->fetch_array($query)) {
		return $value['status'];
	} else {
		return -1;//没有记录
	}
}

//重新组建
function renum($array) {
	$newnums = $nums = array();
	foreach ($array as $id => $num) {
		$newnums[$num][] = $id;
		$nums[$num] = $num;
	}
	return array($nums, $newnums);
}

//检查定向
function ckfriend($touid, $friend, $target_ids='') {
	global $_SGLOBAL, $_SC, $_SCONFIG, $_SCOOKIE, $space;

	//游客
	if(empty($_SGLOBAL['supe_uid'])) {
		return $friend?false:true;
	}
	
	//自己
	if($touid == $_SGLOBAL['supe_uid']) return true;//自己
	
	$var = 'ckfriend_'.md5($touid.'_'.$friend.'_'.$target_ids);
	if(isset($_SGLOBAL[$var])) return $_SGLOBAL[$var];

	$_SGLOBAL[$var] = false;
	switch ($friend) {
		case 0://全站用户可见
			$_SGLOBAL[$var] = true;
			break;
		case 1://全好友可见
			if($space['uid'] == $touid) {
				if($space['friends'] && in_array($_SGLOBAL['supe_uid'], $space['friends'])) {
					$_SGLOBAL[$var] = true;
				}
			} else {
				$_SGLOBAL[$var] = getfriendstatus($_SGLOBAL['supe_uid'], $touid)==1?true:false;
			}
			break;
		case 2://仅指定好友可见
			if($target_ids) {
				$target_ids = explode(',', $target_ids);
				if(in_array($_SGLOBAL['supe_uid'], $target_ids)) $_SGLOBAL[$var] = true;
			}
			break;
		case 3://仅自己可见
			break;
		case 4://凭密码查看
			$_SGLOBAL[$var] = true;
			break;
		default:
			break;
	}
	return $_SGLOBAL[$var];
}

//整理feed
function mkfeed($feed, $actors=array()) {
	global $_SGLOBAL, $_SN, $_SCONFIG;

	$feed['title_data'] = empty($feed['title_data'])?array():unserialize($feed['title_data']);
	if(!is_array($feed['title_data'])) $feed['title_data'] = array();
	$feed['body_data'] = empty($feed['body_data'])?array():unserialize($feed['body_data']);
	if(!is_array($feed['body_data'])) $feed['body_data'] = array();

	//title
	$searchs = $replaces = array();
	if($feed['title_data'] && is_array($feed['title_data'])) {
		foreach (array_keys($feed['title_data']) as $key) {
			$searchs[] = '{'.$key.'}';
			$replaces[] = $feed['title_data'][$key];
		}
	}

	$searchs[] = '{actor}';
	$replaces[] = empty($actors)?"<a href=\"space.php?do=feed&uid=$feed[uid]\">".$feed[username]."</a>":implode(lang('dot'), $actors);

	$searchs[] = '{app}';
	if(empty($_SGLOBAL['app'][$feed['appid']])) {
		$replaces[] = '';
	} else {
		$app = $_SGLOBAL['app'][$feed['appid']];
		$replaces[] = "<a href=\"$app[url]\">$app[name]</a>";
	}
	$feed['title_template'] = mktarget(str_replace($searchs, $replaces, $feed['title_template']));

	//body
	$searchs = $replaces = array();
	if($feed['body_data'] && is_array($feed['body_data'])) {
		foreach (array_keys($feed['body_data']) as $key) {
			$searchs[] = '{'.$key.'}';
			$replaces[] = $feed['body_data'][$key];
		}
	}
	
	$feed['magic_class'] = '';
	if($feed['appid']) {
		if(!empty($feed['body_data']['magic_color'])) {
			$feed['magic_class'] = 'magiccolor'.$feed['body_data']['magic_color'];
		}
		if(!empty($feed['body_data']['magic_thunder'])) {
			$feed['magic_class'] = 'magicthunder';
		}
	}
	
	$searchs[] = '{actor}';
	$replaces[] = "<a href=\"space.php?do=feed&uid=$feed[uid]\">$feed[username]</a>";
	$feed['body_template'] = mktarget(str_replace($searchs, $replaces, $feed['body_template']));

	$feed['body_general'] = mktarget($feed['body_general']);

	//icon
	if($feed['appid']) {
		$feed['icon_image'] = "image/icon/{$feed['icon']}.gif";
	} else {
		$feed['icon_image'] = "http://appicon.manyou.com/icons/{$feed['icon']}";
	}

	//阅读
	$feed['style'] = $feed['target'] = '';
	if($_SCONFIG['feedread'] && empty($feed['id'])) {
		$read_feed_ids = empty($_COOKIE['read_feed_ids'])?array():explode(',',$_COOKIE['read_feed_ids']);
		if($read_feed_ids && in_array($feed['feedid'], $read_feed_ids)) {
			$feed['style'] = " class=\"feedread\"";
		} else {
			$feed['style'] = " onclick=\"readfeed(this, $feed[feedid]);\"";
		}
	}
	if($_SCONFIG['feedtargetblank']) {
		$feed['target'] = ' target="_blank"';
	}

	//管理
	if(in_array($feed['idtype'], array('blogid','picid','sid','pid','eventid'))) {
		$feed['showmanage'] = 1;
	}
	
	//是否自身应用
	$feed['thisapp'] = 0;
	if($feed['appid'] == UC_APPID) {
		$feed['thisapp'] = 1;
	}

	return $feed;
}

//整理feed的链接
function mktarget($html) {
	global $_SCONFIG;

	if($html && $_SCONFIG['feedtargetblank']) {
		$html = preg_replace("/<a(.+?)href=([\'\"]?)([^>\s]+)\\2([^>]*)>/i", '<a target="_blank" \\1 href="\\3" \\4>', $html);
	}
	return $html;
}

//整理分享
function mkshare($share) {
	$share['body_data'] = unserialize($share['body_data']);

	//body
	$searchs = $replaces = array();
	if($share['body_data']) {
		foreach (array_keys($share['body_data']) as $key) {
			$searchs[] = '{'.$key.'}';
			$replaces[] = $share['body_data'][$key];
		}
	}
	$share['body_template'] = str_replace($searchs, $replaces, $share['body_template']);
	return $share;
}

//ip访问允许
function ipaccess($ipaccess) {
	return empty($ipaccess)?true:preg_match("/^(".str_replace(array("\r\n", ' '), array('|', ''), preg_quote($ipaccess, '/')).")/", getonlineip());
}

//ip访问禁止
function ipbanned($ipbanned) {
	return empty($ipbanned)?false:preg_match("/^(".str_replace(array("\r\n", ' '), array('|', ''), preg_quote($ipbanned, '/')).")/", getonlineip());
}

//检查start
function ckstart($start, $perpage) {
	global $_SCONFIG;

	$maxstart = $perpage*intval($_SCONFIG['maxpage']);
	if($start < 0 || ($maxstart > 0 && $start >= $maxstart)) {
		showmessage('length_is_not_within_the_scope_of');
	}
}

//处理头像
function avatar($uid, $size='small', $returnsrc = FALSE) {
	global $_SCONFIG, $_SN;
	
	$size = in_array($size, array('big', 'middle', 'small')) ? $size : 'small';
	$avatarfile = avatar_file($uid, $size);
/*
	return $returnsrc ? UC_API.'/data/avatar/'.$avatarfile : '<img src="'.UC_API.'/data/avatar/'.$avatarfile.'" onerror="this.onerror=null;this.src=\''.UC_API.'/images/noavatar_'.$size.'.gif\'">';
*/
	return $returnsrc ? 'image/avatar/'.$avatarfile : '<img src="image/avatar/'.$avatarfile.'" onerror="this.onerror=null;this.src=\'images/noavatar_'.$size.'.gif\'">';
}

//得到头像
function avatar_file($uid, $size) {
	global $_SGLOBAL, $_SCONFIG;

	$type = empty($_SCONFIG['avatarreal'])?'virtual':'real';
	$var = "avatarfile_{$uid}_{$size}_{$type}";
	if(empty($_SGLOBAL[$var])) {
		$uid = abs(intval($uid));
		$uid = sprintf("%09d", $uid);
		$dir1 = substr($uid, 0, 3);
		$dir2 = substr($uid, 3, 2);
		$dir3 = substr($uid, 5, 2);
		$typeadd = $type == 'real' ? '_real' : '';
		$_SGLOBAL[$var] = $dir1.'/'.$dir2.'/'.$dir3.'/'.substr($uid, -2).$typeadd."_avatar_$size.jpg";
	}
	return $_SGLOBAL[$var];
}

//检查是否登录
function checklogin() {
	global $_SGLOBAL, $_SCONFIG;

	if(empty($_SGLOBAL['supe_uid'])) {
		ssetcookie('_refer', rawurlencode($_SERVER['REQUEST_URI']));
		showmessage('to_login', 'do.php?ac='.$_SCONFIG['login_action']);
	}
}

//获得前台语言
function lang($key, $vars=array()) {
	global $_SGLOBAL;

	include_once(S_ROOT.'./language/lang_source.php');
	if(isset($_SGLOBAL['sourcelang'][$key])) {
		$result = lang_replace($_SGLOBAL['sourcelang'][$key], $vars);
	} else {
		$result = $key;
	}
	return $result;
}

//获得后台语言
function cplang($key, $vars=array()) {
	global $_SGLOBAL;

	include_once(S_ROOT.'./language/lang_cp.php');
	if(isset($_SGLOBAL['cplang'][$key])) {
		$result = lang_replace($_SGLOBAL['cplang'][$key], $vars);
	} else {
		$result = $key;
	}
	return $result;
}

//语言替换
function lang_replace($text, $vars) {
	if($vars) {
		foreach ($vars as $k => $v) {
			$rk = $k + 1;
			$text = str_replace('\\'.$rk, $v, $text);
		}
	}
	return $text;
}

//获得用户组名
function getfriendgroup() {
	global $_SCONFIG, $space;

	$groups = array();
	$spacegroup = empty($space['privacy']['groupname'])?array():$space['privacy']['groupname'];
	for($i=0; $i<$_SCONFIG['groupnum']; $i++) {
		if($i == 0) {
			$groups[0] = lang('friend_group_default');
		} else {
			if(!empty($spacegroup[$i])) {
				$groups[$i] = $spacegroup[$i];
			} else {
				if($i<8) {
					$groups[$i] = lang('friend_group_'.$i);
				} else {
					$groups[$i] = lang('friend_group').$i;
				}
			}
		}
	}
	return $groups;
}

//截取链接
function sub_url($url, $length) {
	if(strlen($url) > $length) {
		$url = str_replace(array('%3A', '%2F'), array(':', '/'), rawurlencode($url));
		$url = substr($url, 0, intval($length * 0.5)).' ... '.substr($url, - intval($length * 0.3));
	}
	return $url;
}

//获取用户名
function realname_set($uid, $username, $name='', $namestatus=0) {
	/*
	global $_SGLOBAL, $_SN, $_SCONFIG;
	if($name) {
		$_SN[$uid] = ($_SCONFIG['realname'] && $namestatus)?$name:$username;
	} elseif(empty($_SN[$uid])) {
		$_SN[$uid] = $username;
		$_SGLOBAL['select_realname'][$uid] = $uid;//需要检索
	}
	*/
}

//获取实名
function realname_get() {
	/*
	global $_SGLOBAL, $_SCONFIG, $_SN, $space;

	if(empty($_SGLOBAL['_realname_get']) && $_SCONFIG['realname'] && $_SGLOBAL['select_realname']) {
		//禁止重复调用
		$_SGLOBAL['_realname_get'] = 1;

		//已经有的
		if($space && isset($_SGLOBAL['select_realname'][$space['uid']])) {
			unset($_SGLOBAL['select_realname'][$space['uid']]);
		}
		if($_SGLOBAL['member']['uid'] && isset($_SGLOBAL['select_realname'][$_SGLOBAL['member']['uid']])) {
			unset($_SGLOBAL['select_realname'][$_SGLOBAL['member']['uid']]);
		}
		//获得实名
		$uids = empty($_SGLOBAL['select_realname'])?array():array_keys($_SGLOBAL['select_realname']);
		if($uids) {
			$query = $_SGLOBAL['db']->query("SELECT uid, name, namestatus FROM ".tname('space')." WHERE uid IN (".simplode($uids).")");
			while ($value = $_SGLOBAL['db']->fetch_array($query)) {
				if($value['name'] && $value['namestatus']) {
					$_SN[$value['uid']] = $value['name'];
				}
			}
		}
	}
	*/
}

//群组信息
function getmtag($id) {
	global $_SGLOBAL;

	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('mtag')." WHERE tagid='$id'");
	if(!$mtag = $_SGLOBAL['db']->fetch_array($query)) {
		showmessage('designated_election_it_does_not_exist');
	}
	//空群组
	if($mtag['membernum']<1 && ($mtag['joinperm'] || $mtag['viewperm'])) {
		$mtag['joinperm'] = $mtag['viewperm'] = 0;
		updatetable('mtag', array('joinperm'=>0, 'viewperm'=>0), array('tagid'=>$id));
	}

	//处理
	include_once(S_ROOT.'./data/data_profield.php');
	$mtag['field'] = $_SGLOBAL['profield'][$mtag['fieldid']];
	$mtag['title'] = $mtag['field']['title'];
	if(empty($mtag['pic'])) {
		$mtag['pic'] = 'image/nologo.jpg';
	}

	//成员级别
	$mtag['ismember'] = 0;
	$mtag['grade'] = -9;//-9 非成员 -2 申请 -1 禁言 0 普通 1 明星 8 副群主 9 群主
	$query = $_SGLOBAL['db']->query("SELECT grade FROM ".tname('tagspace')." WHERE tagid='$id' AND uid='$_SGLOBAL[supe_uid]' LIMIT 1");
	if($value = $_SGLOBAL['db']->fetch_array($query)) {
		$mtag['grade'] = $value['grade'];
		$mtag['ismember'] = 1;
	}
	if($mtag['grade'] < 9 && checkperm('managemtag')) {
		$mtag['grade'] = 9;
	}
	$mtag['allowthread'] = $mtag['grade']>=0?1:$mtag['threadperm'];
	$mtag['allowpost'] = $mtag['grade']>=0?1:$mtag['postperm'];
	$mtag['allowview'] = ($mtag['viewperm'] && $mtag['grade'] < -1)?0:1;

	$mtag['allowinvite'] = $mtag['grade']>=0?1:0;
	if($mtag['joinperm'] && $mtag['grade'] < 8) {
		$mtag['allowinvite'] = 0;
	}
	
	if($mtag['close']) {
		$mtag['allowpost'] = $mtag['allowthread'] = 0;
	}

	return $mtag;
}

//取数组中的随机个
function sarray_rand($arr, $num=1) {
	$r_values = array();
	if($arr && count($arr) > $num) {
		if($num > 1) {
			$r_keys = array_rand($arr, $num);
			foreach ($r_keys as $key) {
				$r_values[$key] = $arr[$key];
			}
		} else {
			$r_key = array_rand($arr, 1);
			$r_values[$r_key] = $arr[$r_key];
		}
	} else {
		$r_values = $arr;
	}
	return $r_values;
}

//获得用户唯一串
function space_key($space, $appid=0) {
	global $_SCONFIG;
	return substr(md5($_SCONFIG['sitekey'].'|'.$space['uid'].(empty($appid)?'':'|'.$appid)), 8, 16);
}

//获得用户URL
function space_domain($space) {
	global $_SCONFIG;

	if($space['domain'] && $_SCONFIG['allowdomain'] && $_SCONFIG['domainroot']) {
		$space['domainurl'] = 'http://'.$space['domain'].'.'.$_SCONFIG['domainroot'];
	} else {
		if($_SCONFIG['allowrewrite']) {
			$space['domainurl'] = getsiteurl().$space[uid];
		} else {
			$space['domainurl'] = getsiteurl()."?$space[uid]";
		}
	}
	return $space['domainurl'];
}

//产生form防伪码
function formhash() {
	global $_SGLOBAL, $_SCONFIG;

	if(empty($_SGLOBAL['formhash'])) {
		$hashadd = defined('IN_ADMINCP') ? 'Only For UCenter Home AdminCP' : '';
		$_SGLOBAL['formhash'] = substr(md5(substr($_SGLOBAL['timestamp'], 0, -7).'|'.$_SGLOBAL['supe_uid'].'|'.md5($_SCONFIG['sitekey']).'|'.$hashadd), 8, 8);
	}
	return $_SGLOBAL['formhash'];
}

//检查邮箱是否有效
function isemail($email) {
	return strlen($email) > 6 && preg_match("/^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/", $email);
}

//验证提问
function question() {
	global $_SGLOBAL;

	include_once(S_ROOT.'./data/data_spam.php');
	if($_SGLOBAL['spam']['question']) {
		$count = count($_SGLOBAL['spam']['question']);
		$key = $count>1?mt_rand(0, $count-1):0;
		ssetcookie('seccode', $key);
		echo $_SGLOBAL['spam']['question'][$key];
	}
}

//输出MYOP升级信息脚本
function my_checkupdate() {
	global $_SGLOBAL, $_SCONFIG;
	if($_SCONFIG['my_status'] && empty($_SCONFIG['my_closecheckupdate']) && checkperm('admin')) {
		$sid = $_SCONFIG['my_siteid'];
		$ts = $_SGLOBAL['timestamp'];
		$key = md5($sid.$ts.$_SCONFIG['my_sitekey']);
		echo '<script type="text/javascript" src="http://notice.uchome.manyou.com/notice?sId='.$sid.'&ts='.$ts.'&key='.$key.'" charset="UTF-8"></script>';
	}
}

//获得用户组图标
function g_icon($gid) {
	global $_SGLOBAL;
	include_once(S_ROOT.'./data/data_usergroup.php');
	if(empty($_SGLOBAL['grouptitle'][$gid]['icon'])) {
		echo '';
	} else {
		echo ' <img src="'.$_SGLOBAL['grouptitle'][$gid]['icon'].'" align="absmiddle"> ';
	}
}

//获得用户颜色
function g_color($gid) {
	global $_SGLOBAL;
	include_once(S_ROOT.'./data/data_usergroup.php');
	if(empty($_SGLOBAL['grouptitle'][$gid]['color'])) {
		echo '';
	} else {
		echo ' style="color:'.$_SGLOBAL['grouptitle'][$gid]['color'].';"';
	}
}

//检查是否操作创始人
function ckfounder($uid) {
	global $_SC;

	$founders = empty($_SC['founder'])?array():explode(',', $_SC['founder']);
	if($uid && $founders) {
		return in_array($uid, $founders);
	} else {
		return false;
	}
}

//获取目录
function sreaddir($dir, $extarr=array()) {
	$dirs = array();
	if($dh = opendir($dir)) {
		while (($file = readdir($dh)) !== false) {
			if(!empty($extarr) && is_array($extarr)) {
				if(in_array(strtolower(fileext($file)), $extarr)) {
					$dirs[] = $file;
				}
			} else if($file != '.' && $file != '..') {
				$dirs[] = $file;
			}
		}
		closedir($dh);
	}
	return $dirs;
}

//获取指定动作能获得多少积分
function getreward($action, $update=1, $uid=0, $needle='', $setcookie = 1) {
	global $_SGLOBAL, $_SCOOKIE;

	$credit = 0;
	$reward = array(
		'credit' => 0,
		'experience' => 0
	);
	$creditlog = array();
	@include_once(S_ROOT.'./data/data_creditrule.php');
	$rule = $_SGLOBAL['creditrule'][$action];

	if($rule['credit'] || $rule['experience']) {
		$uid = $uid ? intval($uid) : $_SGLOBAL['supe_uid'];
		if($rule['rewardtype']) {
			//增加积分
			$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('creditlog')." WHERE uid='$uid' AND rid='$rule[rid]'");
			$creditlog = $_SGLOBAL['db']->fetch_array($query);

			if(empty($creditlog)) {
				$reward['credit'] = $rule['credit'];
				$reward['experience'] = $rule['experience'];
				$setarr = array(
					'uid' => $uid,
					'rid' => $rule['rid'],
					'total' => 1,
					'cyclenum' => 1,
					'credit' => $rule['credit'],
					'experience' => $rule['experience'],
					'dateline' => $_SGLOBAL['timestamp']
				);
				//判断是否需要去重
				if($rule['norepeat']) {
					if($rule['norepeat'] == 1) {
						$setarr['info'] = $needle;
					} elseif($rule['norepeat'] == 2) {
						$setarr['user'] = $needle;
					} elseif($rule['norepeat'] == 3) {
						$setarr['app'] = $needle;
					}
				}

				if(in_array($rule['cycletype'], array(2,3))) {
					$setarr['starttime'] = $_SGLOBAL['timestamp'];
				}
				$clid = inserttable('creditlog', $setarr, 1);
			} else {
				$newcycle = false;
				$setarr = array();
				$clid = $creditlog['clid'];
				switch($rule['cycletype']) {
					case 0:		//一次性奖励
						break;
					case 1:		//每天限次数
					case 4:		//不限周期
						$sql = 'cyclenum+1';
						if($rule['cycletype'] == 1) {
							$today = sstrtotime(sgmdate('Y-m-d'));
							//判断是否为昨天
							if($creditlog['dateline'] < $today && $rule['rewardnum']) {
								$creditlog['cyclenum'] =  0;
								$sql = 1;
								$newcycle = true;
							}
						}
						if(empty($rule['rewardnum']) || $creditlog['cyclenum'] < $rule['rewardnum']) {
							//验证是否为需要去重操作
							if($rule['norepeat']) {
								$repeat = checkcheating($creditlog, $needle, $rule['norepeat']);
								if($repeat && !$newcycle) {
									return $reward;
								}
							}
							$reward['credit'] = $rule['credit'];
							$reward['experience'] = $rule['experience'];
							//更新次数
							$setarr = array(
								'cyclenum' => "cyclenum=$sql",
								'total' => 'total=total+1',
								'dateline' => "dateline='$_SGLOBAL[timestamp]'",
								'credit' => "credit='$reward[credit]'",
								'experience' => "experience='$reward[experience]'",
							);
						}
						break;

					case 2:		//整点
					case 3:		//间隔分钟
						$nextcycle = 0;
						if($creditlog['starttime']) {
							if($rule['cycletype'] == 2) {
								//上一次执行时间
								$start = sstrtotime(sgmdate('Y-m-d H:00:00', $creditlog['starttime']));
								$nextcycle = $start+$rule['cycletime']*3600;
							} else {
								$nextcycle = $creditlog['starttime']+$rule['cycletime']*60;
							}
						}
						if($_SGLOBAL['timestamp'] <= $nextcycle && $creditlog['cyclenum'] < $rule['rewardnum']) {
							//验证是否为需要去重操作
							if($rule['norepeat']) {
								$repeat = checkcheating($creditlog, $needle, $rule['norepeat']);
								if($repeat && !$newcycle) {
									return $reward;
								}
							}
							$reward['experience'] = $rule['experience'];
							$reward['credit'] = $rule['credit'];

							$setarr = array(
								'cyclenum' => "cyclenum=cyclenum+1",
								'total' => 'total=total+1',
								'dateline' => "dateline='$_SGLOBAL[timestamp]'",
								'credit' => "credit='$reward[credit]'",
								'experience' => "experience='$reward[experience]'",
							);
						} elseif($_SGLOBAL['timestamp'] >= $nextcycle) {
							$newcycle = true;
							$reward['experience'] = $rule['experience'];
							$reward['credit'] = $rule['credit'];

							$setarr = array(
								'cyclenum' => "cyclenum=1",
								'total' => 'total=total+1',
								'dateline' => "dateline='$_SGLOBAL[timestamp]'",
								'credit' => "credit='$reward[credit]'",
								'starttime' => "starttime='$_SGLOBAL[timestamp]'",
								'experience' => "experience='$reward[experience]'",
							);
						}
						break;
				}

				//记录操作历史
				if($rule['norepeat'] && $needle) {
					switch($rule['norepeat']) {
						case 0:
							break;
						case 1:		//信息去重
							$info = empty($creditlog['info'])||$newcycle ? $needle : $creditlog['info'].','.$needle;
							$setarr['info'] = "`info`='$info'";
							break;
						case 2:		//用户去重
							$user = empty($creditlog['user'])||$newcycle ? $needle : $creditlog['user'].','.$needle;
							$setarr['user'] = "`user`='$user'";
							break;
						case 3:		//应用去重
							$app = empty($creditlog['app'])||$newcycle ? $needle : $creditlog['app'].','.$needle;
							$setarr['app'] = "`app`='$app'";
							break;
					}
				}
				if($setarr) {
					$_SGLOBAL['db']->query("UPDATE ".tname('creditlog')." SET ".implode(',', $setarr)." WHERE clid='$creditlog[clid]'");
				}

			}
			if($setcookie && $uid = $_SGLOBAL['supe_uid']) {
				//其中有新值时才重写cookie值
				if($reward['credit'] || $reward['experience']) {
					$logstr = $action.','.$clid;
					ssetcookie('reward_log', $logstr);
					$_SCOOKIE['reward_log'] = $logstr;
				}
			}
		} else {
			//扣除积分
			$reward['credit'] = "-$rule[credit]";
			$reward['experience'] = "-$rule[experience]";
		}
		if($update && ($reward['credit'] || $reward['experience'])) {
			$setarr = array();
			if($reward['credit']) {
				$setarr['credit'] = "credit=credit+$reward[credit]";
			}
			if($reward['experience']) {
				$setarr['experience'] = "experience=experience+$reward[experience]";
			}
			$_SGLOBAL['db']->query("UPDATE ".tname('space')." SET ".implode(',', $setarr)." WHERE uid='$uid'");
		}
	}
	return array('credit'=>abs($reward['credit']), 'experience' => abs($reward['experience']));
}

//防积分重复奖励同个人或同信息
function checkcheating($creditlog, $needle, $norepeat) {

	$repeat = false;
	switch($norepeat) {
		case 0:
			break;
		case 1:		//信息去重
			$infoarr = explode(',', $creditlog['info']);
			if(in_array($needle, $infoarr)) {
				$repeat = true;
			}
			break;
		case 2:		//用户去重
			$userarr = explode(',', $creditlog['user']);
			if(in_array($needle, $userarr)) {
				$repeat = true;
			}
			break;
		case 3:		//应用去重
			$apparr = explode(',', $creditlog['app']);
			if(in_array($needle, $apparr)) {
				$repeat = true;
			}
			break;
	}

	return $repeat;
}

//获得热点
function topic_get($topicid) {
	global $_SGLOBAL;
	$topic = array();
	if($topicid) {
		$typearr = array('blog','pic','thread','poll','event','share');
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('topic')." WHERE topicid='$topicid'");
		if($topic = $_SGLOBAL['db']->fetch_array($query)) {
			$topic['pic'] = $topic['pic']?pic_get($topic['pic'], $topic['thumb'], $topic['remote'], 0):'';
			$topic['joingid'] = empty($topic['joingid'])?array():explode(',', $topic['joingid']);
			$topic['jointype'] = empty($topic['jointype'])? $typearr:explode(',', $topic['jointype']);
			$topic['lastpost'] = sgmdate('Y-m-d H:i', $topic['lastpost']);
			$topic['dateline'] = sgmdate('Y-m-d H:i', $topic['dateline']);
			$topic['allowjoin'] = $topic['endtime'] && $_SGLOBAL['timestamp']>$topic['endtime']?0:1;
			$topic['endtime'] = $topic['endtime']?sgmdate('Y-m-d H:i', $topic['endtime']):'';
			
			include_once(S_ROOT.'./source/function_bbcode.php');
			$topic['message'] = bbcode($topic['message'], 1);
			$topic['joinurl'] = '';
			foreach ($typearr as $value) {
				if(in_array($value, $topic['jointype'])) {
					if($value == 'pic') $value = 'upload';
					$topic['joinurl'] = "cp.php?ac=$value&topicid=$topicid";
					break;
				}
			}
		}
	}
	return $topic;
}

//自定义分页
function mob_perpage($perpage) {
	global $_SGLOBAL;

	$newperpage = isset($_GET['perpage'])?intval($_GET['perpage']):0;
	if($_SGLOBAL['mobile'] && $newperpage>0 && $newperpage<500) {
		$perpage = $newperpage;
	}
	return $perpage;
}

//检查用户的特殊身份
function ckspacelog() {
	global $_SGLOBAL;
	
	if(empty($_SGLOBAL['supe_uid'])) return false;
	$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('spacelog')." WHERE uid='$_SGLOBAL[supe_uid]'");
	if($value = $_SGLOBAL['db']->fetch_array($query)) {
		if($value['expiration'] && $value['expiration'] <= $_SGLOBAL['timestamp']) {//到期
			$_SGLOBAL['db']->query("DELETE FROM ".tname('spacelog')." WHERE uid='$_SGLOBAL[supe_uid]'");
		}
		$expiration = sgmdate('Y-m-d H:i', $value['expiration']);
		showmessage('no_authority_expiration'.($value['expiration']?'_date':''), '', 1, array($expiration));
	}
}
function createChildMenu($query,$func,$browserid,$groupid,$idstr,$doshowit)
{
	global $_SGLOBAL,$_SC;	
	if(empty($_SGLOBAL['supe_uid'])) return false;
	
	$do_ul=1;
    if($idstr=="menu"){
		if($browserid==$_SGLOBAL['browsertype']['firefox'])
		{
			echo '<li><a id="menuroot"'.(empty($groupid)?'class="green"':'').' href="space.php?do=bookmark&op=browser&browserid='.$browserid.'" value="根目录">根目录</a></li>';
		}else{
			echo '<li><a id="menuroot"'.(empty($groupid)?'class="green"':'').' href="javascript:;" onclick="'.$func.'(\'0\',\''.$browserid.'\',\'根目录\');" value="根目录">根目录</a></li>';
		}
            echo '<ul id="menu">';
	}
	while ($value= $_SGLOBAL['db']->fetch_array($query)) {
					$do_showit=0;
					if(($value[parentid]==$groupid))
						$do_showit=1;
						//category
			  		if($do_ul&&$idstr!="menu"){ 
			  				//if($doshowit)
			  				//	echo '<ul id="'.$idstr.'" class="showit" style="display:none;">';
			  				//else
			  					echo '<ul id="'.$idstr.'" style="display:none;">';
			  		}
					
					//检查是不是root，就是书签工具栏与书签菜单栏
					$isroot=0;
					if($browserid==$_SGLOBAL['browsertype']['firefox'])
					{
						if(($value[groupid]==$_SGLOBAL['firefox_menu_groupid'])||($value[groupid]==$_SGLOBAL['firefox_tool_groupid']))
							$isroot=1;

					}
					 echo '<li><a href="javascript:;" onclick="'.$func.'(\''.$value[groupid].'\',\''.$browserid.'\',\''.$value[subject].'\','.$isroot.');" value="'.$value[subject].'"'.'class="'.
								(($value[groupid]==$groupid)?(' green '):' ').
								(($value[groupid]==$groupid||$value[parentid]==$groupid)?(' showit '):' ').'"'.'>'.$value[subject].'</a>';
			  		//printf("<li><a href=\"#\">%s</a>\n",mb_substr($value[subject], 0, 15, 'utf-8'));
					/*
			  		if($do_showit)
			  			echo '<li><a href="javascript:;" onclick="'.$func.'(\''.$value[groupid].'\',\''.$browserid.'\',\''.$value[subject].'\','.$isroot.');" class="showit" value="'.$value[subject].'"'.
						(($value[groupid]==$groupid)?('class="green"'):'').'>'.$value[subject].'</a>';
			  		else
			  			echo '<li><a href="javascript:;" onclick="'.$func.'(\''.$value[groupid].'\',\''.$browserid.'\',\''.$value[subject].'\','.$isroot.');" value="'.$value[subject].'"'.
						(($value[groupid]==$groupid)?('class="green"'):'').'>'.$value[subject].'</a>';
					*/
			  		$childQuery=$_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=$value[groupid]");
			  		createChildMenu($childQuery,$func,$browserid,$groupid,$idstr.$value[groupid],$do_showit);		
			  		echo '</li>';				  		
			  		$do_ul=0; 
			  	//  break;			
	}

	if(!$do_ul&&$idstr!="menu")
		echo '</ul>';
    if($idstr=="menu")
       echo '</ul>'; 
}
function usermenuchild($browserid,$groupid,$func,$value)
{
	foreach($value as $key=>$a)
	{
		   $isroot=0;
		   if($browserid==$_SGLOBAL['browsertype']['firefox'])
			{
				if(($a[groupid]==$_SGLOBAL['firefox_menu_groupid'])||($a[groupid]==$a['firefox_tool_groupid']))
					$isroot=1;

			}
		   echo '<li><a href="javascript:;" onclick="'.$func.'(\''.$a[groupid].'\',\''.$browserid.'\',\''.$a[subject].'\','.$isroot.');" value="'.$a[subject].'"'.'class="'.
								(($a[groupid]==$groupid)?(' green '):' ').
								(($a[groupid]==$groupid||$a[parentid]==$groupid)?(' showit '):' ').'"'.'>'.$a[subject].'</a>';
		   if(!empty($a['son']))
			{
					echo '<ul id="menu'.$a['groupid'].'">';
					usermenuchild($browserid,$groupid,$func,$a['son']);
					echo '</ul>';
			}
		  echo '</li>';
   }
}
function usermenu($browserid,$groupid,$func){
	global $_SGLOBAL,$_SC;
	if(empty($_SGLOBAL['supe_uid'])) return false;
	//先检查cache
	if(file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/usermenu.php'))
	{
		include_once(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/usermenu.php');
		//echo '<li><a id="menuroot"'.(empty($groupid)?'class="green"':'').' href="space.php?do=bookmark&op=browser&browserid='.$browserid.'" value="根目录">根目录</a></li>';
		echo '<li><a id="menuroot"'.(empty($groupid)?'class="green"':'').' href="javascript:;" onclick="'.$func.'(\'0\',\''.$browserid.'\',\'根目录\');" value="根目录">根目录</a></li>';
		echo '<ul id="menu">';
		usermenuchild($browserid,$groupid,$func,$_SGLOBAL['usermenu'][$browserid][0]); 		
		echo '</ul>';
	}else{
		usermenu_cache();
		$browserid = (empty($browserid) || !in_array($browserid, $_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:$browserid;
		$query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=0".' AND browserid='.$browserid);
		createChildMenu($query,$func,$browserid,$groupid,"menu");
	}
}

function mkbrowsertab($id)
{
    global $_SGLOBAL;
	//if(empty($_SGLOBAL['supe_uid'])) echo '';
	$browserid = (empty($browserid) || !in_array($browserid, $_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:$browserid;
    foreach($_SGLOBAL['browsertype'] as $key=>$browserid){
		/*
	    echo '<li '.(($browserid==$id)?'class="active"':'').'><a href="space.php?do=bookmark&op=browser&browserid='.$browserid.'"><span>'.$key.'</span></a></li>';
		*/
		 echo '<li '.(($browserid==$id)?'class="active"':'').' id="'.$browserid.'"><a onclick="getbrowserview('.$browserid.')" href="javascript:;" ><span>'.$key.'</span></a></li>';
		
    }
}
function mkbrowsershowtab($id)
{
    global $_SGLOBAL;
	$browserid = (empty($browserid) || !in_array($browserid, $_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:$browserid;
    foreach($_SGLOBAL['browsertype'] as $key=>$browserid){
	    echo '<li '.(($browserid==$id)?'class="active"':'').'><a onclick="getdirtreefrombrowserid('.$browserid.');" href="javascript:;"><span>'.$key.'</span></a></li>';
		/*echo '<li '.(($browserid==$id)?'class="active"':'').'><a href="cp.php?ac=link&op=bookmark&linkid='.$linkid.'&browserid='.$browserid.'">'.$key.'</span></a></li>';*/
    }
}
function checkbrowserid($id)
{
	global $_SGLOBAL;
	if(in_array($id,$_SGLOBAL['browsertype']))
		return 1;
	return 0;
}
function cond_parentid($groupid) {
	return (($groupid==-1)?' ':' and main.parentid='.$groupid);
}
function cond_groupid($groupid) {
	return (($groupid==-1)?' ':' and main.groupid='.$groupid);
}
function getUnicodeFromOneUTF8($word) {   
  if (is_array( $word))   
    $arr = $word;   
  else     
    $arr = str_split($word);    
  $bin_str = '';   
  foreach ($arr as $value)   
    $bin_str .= decbin(ord($value));   
  $bin_str = preg_replace('/^.{4}(.{4}).{2}(.{6}).{2}(.{6})$/','$1$2$3', $bin_str);   
  return bindec($bin_str); 
}
function mbStringToArray ($string) {
    $strlen = mb_strlen($string);
    while ($strlen) {
        $array[] = mb_substr($string,0,1,"UTF-8");
        $string = mb_substr($string,1,$strlen,"UTF-8");
        $strlen = mb_strlen($string);
    }
    return $array;
}
function _qhash($p, $n)
{
    $h = 0;
    $g;
	  $i=0;
    while ($n--) {
        $h = (($h) << 4) + getUnicodeFromOneUTF8($p[$i]);
        if (($g = ($h & 0xf0000000)) != 0)
            $h ^= $g >> 23;
        $h &= ~$g;
				$i++;
    }
    return $h;
}

function qhash($str){
  $t=mbStringToArray($str);
  return _qhash($t,count($t));
}
function getuserbrowserarray(){
        global $_SGLOBAL;
        $userbrowser=array();
        if(!$_SGLOBAL['supe_uid'])
            return $userbrowser;
	    $query=$_SGLOBAL['db']->query("SELECT DISTINCT(browserid) from ".tname('bookmark')." WHERE  uid=".$_SGLOBAL['supe_uid']);
       	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
            $userbrowser[]=$value['browserid'];
		}
        return $userbrowser;
}
function setlinkimagepath($link)
{
	global $_SC;
	$dirrandom=$_SC['link_image_path'].'random/';
	$link['tmppic']=$dirrandom.rand(1,30).$_SC['link_image_suffix'];

	$link['pic']=$_SC['link_image_path'].(($link['hashurl']>>24)%8).'/'.((($link['hashurl']&0x00ff0000)>>16)%8).'/'.((($link['hashurl']&0x0000ff00)>>8)%8).'/'.(($link['hashurl']&0x00ff)%8);
	return $link;
}
/*
	-1:no_authority_to_do_this
	-2:error_parameter
*/
function check_valid($op,$id,$item,$owner,$pristr,$priorityarray)
{
	global $_SGLOBAL;
	if(!in_array($op,array_keys($priorityarray)))
		return -2;
	//全部都不关心则直接返回
	if(($priorityarray[$op]['permit']+$priorityarray[$op]['id']+$priorityarray[$op]['item']+$priorityarray[$op]['owner'])==0)
		return 1;
	if(($priorityarray[$op]['permit']==1)&&(checkperm($pristr)=='0'))
		return -1;
	if(($priorityarray[$op]['id']==1)&&empty($id))
		return -2;
	if(($priorityarray[$op]['item']==1)&&empty($item))
		return -2;
	if(($priorityarray[$op]['owner']==1)&&($owner!=$_SGLOBAL['supe_uid']))
		return -1;
	$option=array();
	$ret=0;
	foreach($priorityarray[$op] as $key=>$value)
	{
		if($value==2)
			$option[]=$key;
	}	
	foreach($option as $value)
	{
		if($value=='permit')
			$ret|=checkperm($pristr);
		else if($value=='owner')
			$ret|=($owner==$_SGLOBAL['supe_uid']);
		else if($value=='id')
			$ret|=!empty($id);
		else if($value=='item')
			$ret|=!empty($item);
	}
	if(!empty($option)&&!$ret)
		return -1;
	return 1;
}
$jquerydojs=array('all','bookmark','digg','link','site');

function exitwithtip($tip)
{
	echo $tip;
	exit();
}

/*
	create bookmark xml
*/
function createCategory($arr)
{
		global $_SGLOBAL,$_SC;
		$groupid=(int)$arr['groupid'];	
	   	printf("<category groupId=\"$groupid\" parentId=\"$arr[parentid]\">\n");
	   	printf("<name><![CDATA[%s]]></name>\n",unshtmlspecialchars($arr['subject']));
	   	printf("<bmid><![CDATA[%d]]></bmid>\n",$arr['bmid']);
		//printf("<bmid><![CDATA[%d]]></bmid>\n",$arr['groupid']);
	   	printf("<adddate><![CDATA[%s]]></adddate>\n",$arr['dateline']);
	   //	printf("<modifydate><![CDATA[%s]]></modifydate>\n",$row[8]);
	   $wherearr=$wherearr." where main.uid=".$arr['uid'] ;
	   $wherearr=$wherearr." AND main.browserid=".$arr['browserid'];
	   $wherearr=$wherearr." AND main.parentid=".$groupid; 

	   $orderarr=$orderarr." ORDER by main.lastvisit DESC ";

	    $query = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main	LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid ".$wherearr.$orderarr);
	    while ($value = $_SGLOBAL['db']->fetch_array($query)) {
	   		    switch($value['type'])
					   {
					   	case $_SC['bookmark_type_dir']://category
					   	  createCategory($value);
					   	break;
					   	case $_SC['bookmark_type_site']://item
						   	printf("<item parentId=\"$value[parentid]\">\n");
						   	printf("<name><![CDATA[%s]]></name>\n",unshtmlspecialchars($value[subject]));
						   	printf("<link><![CDATA[%s]]></link>\n",unshtmlspecialchars($value['url']));
							printf("<bmid><![CDATA[%d]]></bmid>\n",$value['bmid']);
						   	printf("<adddate><![CDATA[%s]]></adddate>\n",$value['dateline']);
						 //  	printf("<modifydate><![CDATA[%s]]></modifydate>\n",$row[8]);
						   	printf("</item>\n");
					   	break;
					   }
	   	}
	   	printf("</category >\n");
}
function producebmxml($uid,$arr)
{
	global $_SGLOBAL,$_SC;

	$lastupdatetime=isset($arr['tm'])?($arr['tm']):'';
	$lastmodified=$_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT lastmodified FROM ".tname('space')." WHERE uid=".$_SGLOBAL['supe_uid']));
	if($lastupdatetime==$lastmodified)
	{
		//do nothing
		header('md5key:'.md5('do_nothing')); 
		exitwithtip('do_nothing');
	}
	$xmlfile = S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bmxml.xml';
	if($lastupdatetime==''||$lastupdatetime=='0'||!file_exists($xmlfile)){
		bmxml_cache();
	}
	header('md5key:'.md5_file($xmlfile)); 
	if($fp=fopen($xmlfile,'rb'))
	{
		while (!feof($fp)) {
			$buffer = fread($fp, 1024); 
			echo $buffer; 
		}
		fclose($fp);
	}
/*
	printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
	printf("<bookmark version=\"1.0\" updateTime=\"%s\">\n",$lastmodified);
	foreach($_SGLOBAL['browsertype'] as $key=>$browservalue){
		printf("<browserType name=\"$key\">\n");
		$wherearr='';
		$orderarr='';
		$wherearr=$wherearr." where main.uid=".$uid ;
		$wherearr=$wherearr." AND main.browserid=".$browservalue;
		$wherearr=$wherearr." AND main.parentid=0"; 

		$orderarr=$orderarr." ORDER by main.lastvisit DESC ";

		$query = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main	LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid ".$wherearr.$orderarr);
		while ($value = $_SGLOBAL['db']->fetch_array($query)) {
			switch($value['type'])
			{
				case $_SC['bookmark_type_dir']:
					//category
					createCategory($value);
					break;
				case $_SC['bookmark_type_site']:
						printf("<item parentId=\"%d\">\n",$value['groupid']);
						printf("<name><![CDATA[%s]]></name>\n",unshtmlspecialchars($value['subject']));
						printf("<link><![CDATA[%s]]></link>\n",unshtmlspecialchars($value['url']));
						printf("<bmid><![CDATA[%d]]></bmid>\n",$value['bmid']);
						printf("<adddate><![CDATA[%s]]></adddate>\n",$value['dateline']);
						//echo "<modifydate><![CDATA[%s]]></modifydate>\n",$row[8]);
						printf("</item>\n");
				break;
			}
		}
		printf("</browserType>\n");
	}
    printf("</bookmark>\n");
*/
}



/*encrypt*/
/*
	0    1    2	   3    4   5   6   7   8    9    

0   a	 b    c    d    e   f   g   h   i    j    

1	l    m    n    o    p   q   r   s   t    u   

2	w    x    y    z    A   B   C   D   E    F   

3	H    I    J    K    L   M   N   O   P    Q   

4   S    T    U    V    W   X   Y   Z   0    1   

5	3	 4	  5	   6    7   8   9   ~   `    !   

6   #    $    %    ^    &   *   (   )   -    -    

7   =    |    \    {    }   [   ]   :   ;    "    

8   <    >    ,    .    ?   /   k   v   G    R   

9	2	 @	 +	   ' 	0   0   0   0   0    0 
*/
$encrypt_h=9;
$encrypt_v=9;
$encrypt_key=array(
	array('1','a','w','s','4','r','t','5','f','e'),
	array('2','5','t','7','g','8','s','h','b','k'),
	array('4','a','y','w','e','v','6','5','9','m'),
	array('2','r','q','s','4','w','3','5','p','n'),
	array('t','y','w','6','4','l','e','3','f','c')
);
$encrypt_key_index=5;
$encrypt_arr=array(
	'0'=>array('a','b','c','d','e','f','g','h','i','j'),
	'1'=>array('l','m','n','o','p','q','r','s','t','u'),
	'2'=>array('w','x','y','z','A','B','C','D','E','F'), 
	'3'=>array('H','I','J','K','L','M','N','O','P','Q'),
	'4'=>array('S','T','U','V','W','X','Y','Z','0','1'),
	'5'=>array('3','4','5','6','7','8','9','~','`','!'),
	'6'=>array('#','$','%','^','&','*','(',')','-','-'),
	'7'=>array('=','|','\\','{','}','[',']',':',';','\"'),
	'8'=>array('<','>',',','.','?','/','k','v','G','R'),
	'9'=>array('2','@','+','\'',' ','0','0','0','0','0')
);

function encryptstring($para,$secindex)
{
	global $encrypt_h,$encrypt_v,$encrypt_key,$encrypt_arr,$encrypt_key_index;
	$outstr='';
	$para=trim($para);
	$len=strlen($para);
	$secindex=$secindex%$encrypt_key_index;
	$i=0;
	$found=0;
	$found_h=-1;
	$found_v=-1;
	while($i<$len){
		$found=0;
		foreach($encrypt_arr as $key=>$value)
		{
			foreach($value as $k=>$val )
			{
				if($val==$para[$i])
				{
					$found=1;
					$found_v=$k;
					break;
				}
			}
			if($found)
			{
					$found_h=$key;
					break;
			}
		}
		if($found)
			$outstr=$outstr.$encrypt_key[$secindex][$found_h].$encrypt_key[$secindex][$found_v];
		$i++;
	}
	return $outstr;
}
function decryptstring($para,$secindex)
{
	global $encrypt_h,$encrypt_v,$encrypt_key,$encrypt_arr,$encrypt_key_index;
	$outstr='';
	$para=trim($para);
	$len=strlen($para);
	if($len%2)
		return '';
	$secindex=$secindex%$encrypt_key_index;
	$i=0;
	$found=0;
	$found_h=-1;
	$found_v=-1;
	while($i<$len){
			
		foreach($encrypt_key[$secindex] as $key=>$value)
		{
			if($para[$i]==$value)
			{
				$found_h=$key;
				break;
			}

		}
		foreach($encrypt_key[$secindex] as $key=>$value)
		{
			if($para[$i+1]==$value)
			{
				$found_v=$key;
				break;
			}
		}
		$i=$i+2;
		$outstr=$outstr.$encrypt_arr[$found_h][$found_v];		
	}
	return $outstr;
}

function checkclientauth($arr)
{
	global $_SGLOBAL,$encrypt_key_index;
	/*
	$password =$arr['password'];
	$username = trim($arr['username']);
	*/
	$key=isset($arr['authkey'])?intval($arr['authkey']):-1;
	if($key>$encrypt_key_index||$key<0)
	{
		exitwithtip('error_parameter');
	}



	$auth=decryptstring($arr['auth'],$key);

	sscanf($auth,"username=%s password=%s",$username,$password );
	$membername = trim($username);
	

	if(empty($membername)) {
		exitwithtip('users_were_not_empty_please_re_login');
	}
	
	
	//同步获取用户源
	if(!$passport = getpassport($username, $password)) {
		header('md5key:'.md5('login_failure_please_re_login')); 
		exitwithtip('login_failure_please_re_login');
	}
	$_SGLOBAL['supe_uid']=$_SGLOBAL['uid'] = intval($passport['uid']);
	$_SGLOBAL['supe_username']=$_SGLOBAL['username'] = addslashes($passport['username']);
	//echo  $_SGLOBAL['supe_uid'].'  '.$_SGLOBAL['supe_username'];
	return $passport;
}
function isbetween($a,$min,$max)
{
	if(($a<=$min)||($a>=$max))
		return 0;
	else
		return 1;
}
/*
	获取 firefox 书签菜单的groupid
*/
function getFirefoxBookmarkMenuGroupid()
{
	global $_SGLOBAL,$_SC;
	if(empty($_SGLOBAL['supe_uid'])) return 0;
	$browserid = (empty($browserid) || !in_array($browserid, $_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:$browserid;
	$query =$_SGLOBAL['db']->query("SELECT groupid FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=0".' AND browserid='.$_SGLOBAL['browsertype']['firefox']." AND subject='书签菜单' limit 1");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		return $value['groupid'];
	}
	return 0;
}
/*
	获取 firefox 书签工具栏的groupid
*/
function getFirefoxBookmarkToolGroupid()
{
	global $_SGLOBAL,$_SC;
	if(empty($_SGLOBAL['supe_uid'])) return 0;
	$browserid = (empty($browserid) || !in_array($browserid, $_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:$browserid;
	$query =$_SGLOBAL['db']->query("SELECT groupid FROM ".tname('bookmark')." WHERE uid='$_SGLOBAL[supe_uid]' AND type=".$_SC['bookmark_type_dir']." AND parentid=0".' AND browserid='.$_SGLOBAL['browsertype']['firefox']." AND subject='书签工具栏' limit 1");
	while ($value = $_SGLOBAL['db']->fetch_array($query)) {
		return $value['groupid'];
	}
	return 0;
}
/*计算link的award*/
function calc_link_award($init=7000,$store=0,$view=0,$up=0,$down=0)
{
	global $_SGLOBAL,$_SC;
	$val=$init+($_SC['link_award_store_weight']*$store)+($_SC['link_award_view_weight']*$view)+($_SC['link_award_up_weight']*$up)
		-($_SC['link_award_down_weight']*$down);
	if($val<=($_SC['link_award_min']*$_SC['link_award_div']))
		return ($_SC['link_award_min']*$_SC['link_award_div']);
	if($val>=($_SC['link_award_max']*$_SC['link_award_div']))
		return ($_SC['link_award_max']*$_SC['link_award_div']);
	return $val;
}
/*返回link的award*/
function linkaward($val,$flag)
{
	global $_SGLOBAL,$_SC;
	switch($flag)
	{
		case 0://整数
		echo round($val/$_SC['link_award_div']);
		break;
		case 1:
		printf('%02d',round(($val-(round($val/$_SC['link_award_div'])*$_SC['link_award_div']))/10));
		break;
		
	}
	return;
}
function showerrmessage($err)
{
	global $_SGLOBAL,$_SC;
	showmessage($_SC['error'][-1*$err]);
}
function create_cachelock($type)
{
	$lockfile = S_ROOT.'./data/lock/'.$type.'.lock';
	while(1)
	{
		touch($lockfile);
		if(file_exists($lockfile))
			break;
	}
}
function delete_cachelock($type)
{
	$lockfile = S_ROOT.'./data/lock/'.$type.'.lock';
	while(1)
	{
	   unlink($lockfile);
	   if(!file_exists($lockfile))
		   break;
	}
}
function check_cachelock($type)
{
	$lockfile = S_ROOT.'./data/lock/'.$type.'.lock';	
	if(file_exists($lockfile)) 
		return true;
	return false;
}

function getnamefromuid($uid)
{
	global $_SGLOBAL,$_SC,$_SN;
	if(!empty($_SN[$uid]))
		return 	$_SN[$uid];
	$name = $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT name FROM ".tname('member')." where uid=".$uid),0);
	if(!empty($name))
		$_SN[$uid] =  $name;
	return $name;
}
/*
	process the url string:
	remove the end char:'/'
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
function check_cache()
{
	global $_SGLOBAL;	
	include_once(S_ROOT.'./source/function_cache.php');
	//if(empty($_SGLOBAL['linktoolbar']))
	if(!file_exists( S_ROOT.'./data/data_linktoolbar.php')) 
		linktoolbar_cache();
	if(!file_exists( S_ROOT.'./data/data_linktoolbartype.php')) 
		linktoolbartype_cache();
}
/*
	由site得到link
*/
function getlinkfromsite($arr)
{
	global $_SGLOBAL;
	if($arr['siteid']==0)
		return $arr;
	//get site item
	$site_query = $_SGLOBAL['db']->query("SELECT * FROM ".tname('site')." where id=".$arr['siteid']);
	$site = $_SGLOBAL['db']->fetch_array($site_query);	
	if(empty($site))
		return $arr;
	$arr['url'] = $site['url'];
	include_once(S_ROOT.'./source/function_site.php');	
	$arr['link_tag'] = convertsitetag($arr['siteid'],$site['tag']);
	$arr['link_subject'] = preg_replace("/[\s|\n|\r|\f]+/","",$site['name']);
	$arr['link_description'] = $site['remark'];	
	$arr['up']=$site['up'];
	$arr['down']=$site['down'];
	$arr['initaward']=$site['initaward'];
	$arr['award']=$site['award'];
	$arr['storenum']=$site['storenum'];
	$arr['link_viewnum']=$site['viewnum'];
	$arr['picflag']=$site['picflag'];
	return $arr;
}
function getbookmark($bmid)
{
	global $_SGLOBAL;
	$s =array();
	if($bmid<=0)
		return $s;
	$q = $_SGLOBAL['db']->query("SELECT main.*, field.* FROM ".tname('bookmark')." main	LEFT JOIN ".tname('link')." field ON main.linkid=field.linkid where bmid=".$bmid);
	if($s = $_SGLOBAL['db']->fetch_array($q))
	{
	   include_once(S_ROOT.'./source/function_link.php');
	   $s['tag'] = empty($s['tag'])?array():unserialize($s['tag']);
	   if($s['siteid']){
			$s = getlinkfromsite($s);
	   }else{
		   $s['link_tag'] = convertlinktag($s['linkid'],$s['link_tag']);	    
	   }
	   if(empty($s['tag'])) {
			$s['tag']=unserialize($s['link_tag']);
			//如果bookmark的标签为空，则使用link的tag
			if(!empty($s['tag']))
		    {
				include_once(S_ROOT.'./source/function_bookmark.php');
				bookmark_tag_batch($bmid,implode(" ", $s['tag']));
				updatetable('bookmark', array('tag'=>serialize($s['tag'])), array('bmid'=>$bmid));
		    }
		}
	   $s['tags'] = implode(' ',$s['tag']);
	   if(empty($s['description'])) $s['description']=$s['link_description'];	 
	   unset($s['link_description']);
	   unset($s['link_tag']);
	   //去除回车转行制表等特殊字符
	   //$s['subject']=preg_replace("/[\s|\n|\r|\f]+/","",$s['subject']);
	   $s['award'] = calc_link_award($s['initaward'],$s['storenum'],$s['viewnum'],$s['up'],$s['down']);
	} 
	return $s;
}
function getlink($linkid)
{
	global $_SGLOBAL;
	$s =array();
	if($linkid<=0)
		return $s;
	$q = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('link')." main	where linkid=".$linkid);
	if($s = $_SGLOBAL['db']->fetch_array($q))
	{
	   if($s['siteid']){
		//从site中获得link信息
			$s = getlinkfromsite($s);			
	   }else{
		   include_once(S_ROOT.'./source/function_link.php');
		   $s['link_tag'] = convertlinktag($s['linkid'],$s['link_tag']);   
	   }

	   if($s){
		   $s['tag']= empty($s['link_tag'])?array():unserialize($s['link_tag']);
		   $s['description']=$s['link_description'];	
		   //去除回车转行制表等特殊字符
		   $s['subject']=preg_replace("/[\s|\n|\r|\f]+/","",$s['link_subject']);
		   $s['tags'] = implode(' ',$s['tag']);
		   unset($s['link_description']);
		   unset($s['link_tag']);
	   }
	} 	
	
	return $s;
}
function getsite($siteid)
{
	global $_SGLOBAL;
	$s =array();
	if($siteid<=0)
		return $s;
	$q = $_SGLOBAL['db']->query("SELECT main.* FROM ".tname('site')." main	where id=".$siteid);
	if($s = $_SGLOBAL['db']->fetch_array($q))
	{
		   $s['siteid'] = $siteid;
		   //修正award
		   $value['award'] = calc_link_award($value['initaward'],$value['storenum'],$value['viewnum'],$value['up'],$value['down']);
		   updatetable('site', array('award'=>$value['award']),array('id'=>$value['siteid']));
		   include_once(S_ROOT.'./source/function_site.php');
		   $value['tag'] = convertsitetag($value['id'],$value['tag']);
		   $s['tag'] = empty($s['tag'])?array():unserialize($s['tag']);	
		   $s['tags'] = implode(' ',$s['tag']);
			//去除回车转行制表等特殊字符
		   $s['subject']=preg_replace("/[\s|\n|\r|\f]+/","",$s['name']);
		   $s['description']=$s['remark'];
		   unset($s['name']);
		   unset($s['remark']);
	} 	
	return $s;
}
function getsiteclass($id)
{
	global $_SGLOBAL;
	if($id<=0)
		return 0;
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT main.class FROM ".tname('site')." main	where id=".$id),0);
}
function getsiteclassname($classid)
{
	global $_SGLOBAL;
	if($classid<=0)
		return '';
	$q = $_SGLOBAL['db']->query("SELECT main.classname FROM ".tname('siteclass')." main	where classid=".$classid);
	if($s = $_SGLOBAL['db']->fetch_array($q))
	{
		  return $s['classname'];
	} 	
	return '';
}
//获取sitetag的总数
function getsitetagtotalnum($tagid)
{
	global $_SGLOBAL;
	if($tagid<=0)
		return 0;
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(distinct(main.siteid)) FROM ".tname('sitetagsite')." main where main.tagid=".$tagid." AND main.siteid>0 "),0);
}
//获取linktag的总数
function getlinktagtotalnum($tagid)
{
	global $_SGLOBAL;
	if($tagid<=0)
		return 0;
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('sitetagsite')." main where main.uid=".$_SGLOBAL['supe_uid']." AND main.tagid=".$tagid),0);
}
//获取某class中site数目
function getsitetotalnuminclass($classid){
	global $_SGLOBAL;
	if($classid<=0)
		return 0;
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT COUNT(*) FROM ".tname('site')." main where main.class=".$classid),0);

}
//获取tag的名字
function gettagname($tagid)
{
	global $_SGLOBAL;
	if($tagid<=0)
		return '';
	return $_SGLOBAL['db']->result($_SGLOBAL['db']->query("SELECT main.tagname FROM ".tname('sitetag')." main where main.tagid=".$tagid),0);
}
/*
更新顶数，踩数，浏览数
$type:bookmark,link,site
$mode:up down viewnum
*/
function updatestatistic($type,$mode,$ids)
{
		global $_SGLOBAL,$_SC;
        if(!$_SGLOBAL['supe_uid'])
            return;
		$update_table='';
		$update_where = '';
		/*
			$type:uplinkid downbookmarkid
		*/
		if($mode=='up'||$mode=='down')
		{	
				include_once(S_ROOT.'./source/function_feed.php');
				//24小时之内只能顶或踩一次
				if(!feed_publish($ids['feedid'], $type.'_'.$mode, 1))
					return 0;

		}
		switch($type){
			case 'link':
			$update_table = 'link';
			$update_where = 'where linkid='.$ids['updateid'];
			break;
			case 'bookmark':
			if($mode=='up'||$mode=='down'){
				$update_table = 'link';
				$update_where = 'where linkid='.$ids['updateid'];
			}else{
				$update_table = 'bookmark';
				$update_where = 'where bmid='.$ids['updateid'];
				//更新viewnum，同时更新link或site
				if($ids['siteid'])
					$_SGLOBAL['db']->query("UPDATE ".tname('site')." SET ".$mode."=".$mode."+1 where id=".$ids['siteid']);
				else
					$_SGLOBAL['db']->query("UPDATE ".tname('link')." SET ".$mode."=".$mode."+1 where linkid=".$ids['feedid']);
			}
			break;
			case 'site':
			$update_table = 'site';
			$update_where = 'where id='.$ids['updateid'];
			//更新今天的浏览数统计
			if($mode == 'viewnum')
				$_SGLOBAL['db']->query("UPDATE ".tname($update_table)." SET todayviewnum=todayviewnum+1 ".$update_where);
			break;
		
		}
	    $_SGLOBAL['db']->query("UPDATE ".tname($update_table)." SET ".$mode."=".$mode."+1 ".$update_where);
		
		return 1;
}
function strip($data, $editor = false)
{
	$data = strtr($data, '`', '');

	if ($editor == true)
	{
		// 过滤 JavaScript
		$search = array ('#<script[^>]*?>.*?[</script>]*#si', '#<iframe[^>]*?>.*?[</iframe>]*#si', '#<input[^>]*?>#si', '#<button[^>]*?>.*?</button>#si', '#<form[^>]*?>#si', '#</form>#si',
		'#(<[\/\!]*?)?(\ class\=[\'|"].*?[\'|"])|(\ id\=[\'|"].*?[\'|"])([^<>]*?>)?#si');
		$replace = array('', '', '', '', '', '');
		$data = preg_replace($search, $replace, $data);
		if (get_magic_quotes_gpc())
		{
			$data = trim($data);
		}
		else
		{
			$data = addslashes(trim($data));
		}

	}
	else
	{
		if (get_magic_quotes_gpc())
		{
			$data = htmlspecialchars(trim(stripslashes($data)), ENT_QUOTES);
		}
		else
		{
			$data = htmlspecialchars(trim($data), ENT_QUOTES);
		}
	}
	return $data;
}

function get_page_start($perpage)
{
	global $_GET;
	$page=empty($_GET['page'])?1:intval($_GET['page']);
	$start=($page-1)*$perpage;
	return array($page,$start);
}
function gethttpbrowserid()
{
	//如果没指定或指定错误，则为ie
	global $_GET,$_SGLOBAL;
	return  (empty($_GET['browserid'])||!in_array(intval($_GET['browserid']),$_SGLOBAL['browsertype']))?$_SGLOBAL['browsertype']['ie']:intval($_GET['browserid']);
}
function gethttpgroupid($browserid)
{
	global $_GET,$_SGLOBAL;
	$groupid=isset ($_GET['groupid'])?intval($_GET['groupid']):0;
		//firefox做特殊处理，点击根目录直接转到书签菜单
	if(($browserid==$_SGLOBAL['browsertype']['firefox']))
	{
			$_SGLOBAL['firefox_menu_groupid']=getFirefoxBookmarkMenuGroupid();
			$_SGLOBAL['firefox_tool_groupid']=getFirefoxBookmarkToolGroupid();
			if(empty($groupid))
				$groupid=$_SGLOBAL['firefox_menu_groupid'];
	}
	return $groupid;
}
function getbookmarkgroupname($browserid,$groupid){
	global $_SGLOBAL;
	$groupname=(empty($groupid))?'根目录':'';
	if(empty($groupname)){
			//获取groupname	先检查cache
			if(!file_exists(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_groupname.php'))
			{	
					bookmark_groupname_cache();

			}
			include_once(S_ROOT.'./data/bmcache/'.$_SGLOBAL['supe_uid'].'/bookmark_groupname.php');
			$groupname=$_SGLOBAL['bookmark_groupname'][$browserid][$groupid];
			unset($_SGLOBAL['bookmark_groupname']); 
			if(empty($groupname))
				showmessage('error_parameter');			
	}
	return $groupname;
}
function deldir($dir){
	 $dh=opendir($dir);
	 while ($file=readdir($dh)){
		  if($file!="."&&$file!=".."){
			   $fullpath=$dir."/".$file;
				if(!is_dir($fullpath))
					unlink($fullpath);
				else
					deldir($fullpath);   
			  }
		 }
	 closedir($dh);
}
//当link有改变的时候，需更新相对应的bookmark信息,去除存有此link的用户cache
function updatelinkinfo($linkid,$tag='')
{
	global $_SGLOBAL;
	if(!$_SGLOBAL[supe_uid]||!checkperm('manageconfig'))
	return;
	if($linkid<=0)
		return;
	include_once(S_ROOT.'./source/function_link.php');
	convertlinktag($linkid,$tag);

	$fileprefix = S_ROOT.'./data/bmcache/';

	$q = $_SGLOBAL['db']->query("SELECT uid,parentid,browserid FROM ".tname('bookmark')." where linkid=".$linkid);
	while($s = $_SGLOBAL['db']->fetch_array($q))
	{
		unlink($fileprefix.$s['uid'].'/bookmark_'.$s['browserid'].'_'.$s['parentid'].'.txt');
	}
	updatetable('link',array('updateflag'=>0), array('linkid'=>$linkid));
}
function updatelinkall()
{
	global $_SGLOBAL;
	if(!$_SGLOBAL[supe_uid]||!checkperm('manageconfig'))
		return;
	$q = $_SGLOBAL['db']->query("SELECT linkid,link_tag FROM ".tname('link')." where updateflag=1");
	while($s = $_SGLOBAL['db']->fetch_array($q))
	{
		updatelinkinfo($s['linkid'],$s['link_tag']);
	}
}
//site更新后，对应的link对应的bookmark则需要修改
function updatesiteinfo($siteid,$tag)
{
	
	global $_SGLOBAL;
	if(!$_SGLOBAL[supe_uid]||!checkperm('manageconfig'))
	return;
	if($siteid<=0)
		return;
	include_once(S_ROOT.'./source/function_site.php');
	convertsitetag($siteid,$tag);
	
	$classid = getsiteclass($siteid);

	if(!$classid)
			return;
	
	$fileprefix = S_ROOT.'./data/sitecache/';
	
	deldir($fileprefix.$classid);
	
	//所以引用这个site的bookmark也需要更新
	$q = $_SGLOBAL['db']->query("SELECT linkid FROM ".tname('link')." where siteid=".$siteid);
	while($s = $_SGLOBAL['db']->fetch_array($q))
	{
		updatelinkinfo($s['linkid']);
	}
	updatetable('site',array('updateflag'=>0), array('id'=>$siteid));
	
}

function updatesiteall()
{
	global $_SGLOBAL;
	if(!$_SGLOBAL[supe_uid]||!checkperm('manageconfig'))
		return;
	$q = $_SGLOBAL['db']->query("SELECT id,tag FROM ".tname('site')." where updateflag=1");
	while($s = $_SGLOBAL['db']->fetch_array($q))
	{
		updatesiteinfo($s['id'],$s['tag']);
	}
}

function readsitecachefile($type)
{
	$f =  S_ROOT.'./data/site_'.$type.'.txt';
	if(!file_exists($f)){
		include_once(S_ROOT.'./source/function_cache.php');
		site_today_cache($type);
	}
	$ret = unserialize(sreadfile($f));
	$r = array();
	foreach($ret as $k=>$v){
		$r[] = $v;
	}
	return $r;
}
function get_right_refer($at,$groupid,$browserid){
	global $_GET,$_SGLOBAL;
	switch($at){
		case 'lastadd':
			return 'space.php?do=bookmark&op=lastadd';
			break;
		case 'lastvisit':
			return 'space.php?do=bookmark&op=lastvisit';
			break;
		case 'oftenvisit':
			return 'space.php?do=bookmark&op=oftenvisit';
			break;
		default:
			return 'space.php?do=bookmark&op=browser&groupid='.$groupid."&browserid=".$browserid;
			break;
	}
}
function getinitaward($award)
{
	if($award < 7000)
		$award = 7000;
	elseif($award > 9000)
		$award = 9000;
	return $award;
}
?>
