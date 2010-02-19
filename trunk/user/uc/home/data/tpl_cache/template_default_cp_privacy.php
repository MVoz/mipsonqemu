<?php if(!defined('IN_UCHOME')) exit('Access Denied');?><?php subtplcheck('template/default/cp_privacy|template/default/header|template/default/cp_header|template/default/footer', '1266338042', 'template/default/cp_privacy');?><?php if(empty($_SGLOBAL['inajax'])) { ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=<?=$_SC['charset']?>" />
<meta http-equiv="x-ua-compatible" content="ie=7" />
<title><?php if($_TPL['titles']) { ?><?php if(is_array($_TPL['titles'])) { foreach($_TPL['titles'] as $value) { ?><?php if($value) { ?><?=$value?> - <?php } ?><?php } } ?><?php } ?><?php if($_SN[$space['uid']]) { ?><?=$_SN[$space['uid']]?> - <?php } ?><?=$_SCONFIG['sitename']?> - Powered by UCenter Home</title>
<script language="javascript" type="text/javascript" src="source/jquery-1.3.2.min.js"></script>
<script language="javascript" type="text/javascript" src="source/menu.js"></script>
<script language="javascript" type="text/javascript" src="source/script_cookie.js"></script>
<script language="javascript" type="text/javascript" src="source/script_common.js"></script>
<script language="javascript" type="text/javascript" src="source/script_menu.js"></script>
<script language="javascript" type="text/javascript" src="source/script_ajax.js"></script>
<script language="javascript" type="text/javascript" src="source/script_face.js"></script>
<script language="javascript" type="text/javascript" src="source/script_manage.js"></script>

<style type="text/css">
@import url(template/default/style.css);
<?php if($_TPL['css']) { ?>
@import url(template/default/<?=$_TPL['css']?>.css);
<?php } ?>
<?php if(!empty($_SGLOBAL['space_theme'])) { ?>
@import url(theme/<?=$_SGLOBAL['space_theme']?>/style.css);
<?php } elseif($_SCONFIG['template'] != 'default') { ?>
@import url(template/<?=$_SCONFIG['template']?>/style.css);
<?php } ?>
<?php if(!empty($_SGLOBAL['space_css'])) { ?>
<?=$_SGLOBAL['space_css']?>
<?php } ?>
</style>
<link rel="shortcut icon" href="image/favicon.ico" />
<link rel="edituri" type="application/rsd+xml" title="rsd" href="xmlrpc.php?rsd=<?=$space['uid']?>" />
</head>
<body>

<div id="append_parent"></div>
<div id="ajaxwaitid"></div>
<div id="header">
<?php if($_SGLOBAL['ad']['header']) { ?><div id="ad_header"><?php adshow('header'); ?></div><?php } ?>
<div class="headerwarp">
<h1 class="logo"><a href="index.php"><img src="template/<?=$_SCONFIG['template']?>/image/logo.gif" alt="<?=$_SCONFIG['sitename']?>" /></a></h1>
<ul class="menu">
<?php if($_SGLOBAL['supe_uid']) { ?>
<li><a href="space.php?do=home">首页</a></li>
<li><a href="space.php">个人主页</a></li>
<li><a href="space.php?do=friend">好友</a></li>
<li><a href="network.php">随便看看</a></li>
<?php } else { ?>
<li><a href="index.php">首页</a></li>
<?php } ?>

<?php if($_SGLOBAL['appmenu']) { ?>
<?php if($_SGLOBAL['appmenus']) { ?>
<li class="dropmenu" id="ucappmenu" onmouseover="showMenu(this.id)">
<a target="_blank" href="<?=$_SGLOBAL['appmenu']['url']?>" title="<?=$_SGLOBAL['appmenu']['name']?>"><?=$_SGLOBAL['appmenu']['name']?></a>
</li>
<?php } else { ?>
<li><a target="_blank" href="<?=$_SGLOBAL['appmenu']['url']?>" title="<?=$_SGLOBAL['appmenu']['name']?>"><?=$_SGLOBAL['appmenu']['name']?></a></li>
<?php } ?>
<?php } ?>

<?php if($_SGLOBAL['supe_uid']) { ?>
<li><a href="space.php?do=pm<?php if(!empty($_SGLOBAL['member']['newpm'])) { ?>&filter=newpm<?php } ?>">消息<?php if(!empty($_SGLOBAL['member']['newpm'])) { ?>(新)<?php } ?></a></li>
<?php if($_SGLOBAL['member']['allnotenum']) { ?><li class="notify" id="membernotemenu" onmouseover="showMenu(this.id)"><a href="space.php?do=notice"><?=$_SGLOBAL['member']['allnotenum']?>个提醒</a></li><?php } ?>
<?php } else { ?>
<li><a href="help.php">帮助</a></li>
<?php } ?>
</ul>

<div class="nav_account">
<?php if($_SGLOBAL['supe_uid']) { ?>
<a href="space.php?uid=<?=$_SGLOBAL['supe_uid']?>" class="login_thumb"><?php echo avatar($_SGLOBAL[supe_uid]); ?></a>
<a href="space.php?uid=<?=$_SGLOBAL['supe_uid']?>" class="loginName"><?=$_SN[$_SGLOBAL['supe_uid']]?></a>
<?php if($_SGLOBAL['member']['credit']) { ?>
<a href="cp.php?ac=credit" style="font-size:11px;padding:0 0 0 5px;"><img src="image/credit.gif"><?=$_SGLOBAL['member']['credit']?></a>
<?php } ?>
<br />
<?php if(empty($_SCONFIG['closeinvite'])) { ?>
<a href="cp.php?ac=invite">邀请</a> 
<?php } ?>
<a href="cp.php?ac=task">任务</a> 
<a href="cp.php?ac=magic">道具</a>
<a href="cp.php">设置</a> 
<a href="cp.php?ac=common&op=logout&uhash=<?=$_SGLOBAL['uhash']?>">退出</a>
<?php } else { ?>
<a href="do.php?ac=<?=$_SCONFIG['register_action']?>" class="login_thumb"><?php echo avatar($_SGLOBAL[supe_uid]); ?></a>
欢迎您<br>
<a href="do.php?ac=<?=$_SCONFIG['login_action']?>">登录</a> | 
<a href="do.php?ac=<?=$_SCONFIG['register_action']?>">注册</a>
<?php } ?>
</div>
</div>
</div>

<div id="wrap">

<?php if(empty($_TPL['nosidebar'])) { ?>
<div id="main">
<div id="app_sidebar">
<?php if($_SGLOBAL['supe_uid']) { ?>
<ul class="app_list" id="default_userapp">
<li><img src="image/app/doing.gif"><a href="space.php?do=doing">记录</a></li>
<li><img src="image/app/album.gif"><a href="space.php?do=album">相册</a><em><a href="cp.php?ac=upload" class="gray">上传</a></em></li>
<li><img src="image/app/blog.gif"><a href="space.php?do=blog">日志</a><em><a href="cp.php?ac=blog" class="gray">发表</a></em></li>
<li><img src="image/app/poll.gif"/><a href="space.php?do=poll">投票</a><em><a href="cp.php?ac=poll" class="gray">发起</a></em></li>
<li><img src="image/app/mtag.gif"><a href="space.php?do=thread">群组</a><em><a href="cp.php?ac=thread" class="gray">话题</a></em></li>
<li><img src="image/app/event.gif"/><a href="space.php?do=event">活动</a><em><a href="cp.php?ac=event" class="gray">发起</a></em></li>
<li><img src="image/app/share.gif"><a href="space.php?do=share">分享</a></li>
<li><img src="image/app/topic.gif"><a href="space.php?do=topic">热闹</a></li>
</ul>

<ul class="app_list topline" id="my_defaultapp">
<?php if($_SCONFIG['my_status']) { ?>
<?php if(is_array($_SGLOBAL['userapp'])) { foreach($_SGLOBAL['userapp'] as $value) { ?>
<li><img src="http://appicon.manyou.com/icons/<?=$value['appid']?>"><a href="userapp.php?id=<?=$value['appid']?>"><?=$value['appname']?></a></li>
<?php } } ?>
<?php } ?>
</ul>

<?php if($_SCONFIG['my_status']) { ?>
<ul class="app_list topline" id="my_userapp">
<?php if(is_array($_SGLOBAL['my_menu'])) { foreach($_SGLOBAL['my_menu'] as $value) { ?>
<li id="userapp_li_<?=$value['appid']?>"><img src="http://appicon.manyou.com/icons/<?=$value['appid']?>"><a href="userapp.php?id=<?=$value['appid']?>" title="<?=$value['appname']?>"><?=$value['appname']?></a></li>
<?php } } ?>
</ul>
<?php } ?>

<?php if($_SGLOBAL['my_menu_more']) { ?>
<p class="app_more"><a href="javascript:;" id="a_app_more" onclick="userapp_open();" class="off">展开</a></p>
<?php } ?>

<?php if($_SCONFIG['my_status']) { ?>
<div class="app_m">
<ul>
<li><img src="image/app_add.gif"><a href="cp.php?ac=userapp&my_suffix=%2Fapp%2Flist" class="addApp">添加应用</a></li>
<li><img src="image/app_set.gif"><a href="cp.php?ac=userapp&op=menu" class="myApp">管理应用</a></li>
</ul>
</div>
<?php } ?>

<?php } else { ?>
<div class="bar_text">
<form id="loginform" name="loginform" action="do.php?ac=<?=$_SCONFIG['login_action']?>&ref" method="post">
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
<p class="title">登录站点</p>
<p>用户名</p>
<p><input type="text" name="username" id="username" class="t_input" size="15" value="" /></p>
<p>密码</p>
<p><input type="password" name="password" id="password" class="t_input" size="15" value="" /></p>
<p><input type="checkbox" id="cookietime" name="cookietime" value="315360000" checked /><label for="cookietime">记住我</label></p>
<p>
<input type="submit" id="loginsubmit" name="loginsubmit" value="登录" class="submit" />
<input type="button" name="regbutton" value="注册" class="button" onclick="urlto('do.php?ac=<?=$_SCONFIG['register_action']?>');">
</p>
</form>
</div>
<?php } ?>
</div>

<div id="mainarea">

<?php if($_SGLOBAL['ad']['contenttop']) { ?><div id="ad_contenttop"><?php adshow('contenttop'); ?></div><?php } ?>
<?php } ?>

<?php } ?>

<h2 class="title"><img src="image/icon/profile.gif">个人设置</h2>
<div class="tabs_header">
<a href="cp.php?ac=advance" class="r_option">&raquo; 高级管理</a>
<ul class="tabs">
<li<?=$actives['profile']?>><a href="cp.php?ac=profile"><span>个人资料</span></a></li>
<li<?=$actives['avatar']?>><a href="cp.php?ac=avatar"><span>我的头像</span></a></li>
<?php if($_SCONFIG['videophoto']) { ?>
<li<?=$actives['videophoto']?>><a href="cp.php?ac=videophoto"><span>视频认证</span></a></li>
<?php } ?>
<li<?=$actives['credit']?>><a href="cp.php?ac=credit"><span>我的积分</span></a></li>
<?php if($_SCONFIG['allowdomain'] && $_SCONFIG['domainroot'] && checkperm('domainlength')) { ?>
<li<?=$actives['domain']?>><a href="cp.php?ac=domain"><span>我的域名</span></a></li>
<?php } ?>
<?php if($_SCONFIG['sendmailday']) { ?>
<li<?=$actives['sendmail']?>><a href="cp.php?ac=sendmail"><span>邮件提醒</span></a></li>
<?php } ?>
<li<?=$actives['privacy']?>><a href="cp.php?ac=privacy"><span>隐私筛选</span></a></li>
<li<?=$actives['theme']?>><a href="cp.php?ac=theme"><span>个性化设置</span></a></li>
</ul>
</div>

<div class="l_status c_form">
<a href="cp.php?ac=privacy"<?=$cat_actives['base']?>>隐私设置</a><span class="pipe">|</span>
<a href="cp.php?ac=privacy&op=view"<?=$cat_actives['view']?>>动态筛选</a>
</div>


<form method="post" action="cp.php?ac=privacy" class="c_form">

<?php if(empty($_GET['op'])) { ?>
<table cellspacing="0" cellpadding="0" class="formtable">
<caption>
<h2>个人隐私设置</h2>
<p>你可以完全控制哪些人可以看到你的主页上面的内容</p>
</caption>
<tr>
<th width="150">个人主页</th>
<td><select name="privacy[view][index]">
<option value="0"<?=$sels['view']['index']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['index']['1']?>>仅好友可见</option>
<option value="2"<?=$sels['view']['index']['2']?>>仅自己可见</option>
</select></td>
</tr>
<tr>
<th>好友列表</th>
<td><select name="privacy[view][friend]">
<option value="0"<?=$sels['view']['friend']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['friend']['1']?>>仅好友可见</option>
<option value="2"<?=$sels['view']['friend']['2']?>>仅自己可见</option>
</select></td>
</tr>
<tr>
<th>留言板</th>
<td><select name="privacy[view][wall]">
<option value="0"<?=$sels['view']['wall']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['wall']['1']?>>仅好友可见</option>
<option value="2"<?=$sels['view']['wall']['2']?>>仅自己可见</option>
</select></td>
</tr>
<tr>
<th>个人动态</th>
<td><select name="privacy[view][feed]">
<option value="0"<?=$sels['view']['feed']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['feed']['1']?>>仅好友可见</option>
</select></td>
</tr>
<tr>
<th>记录</th>
<td><select name="privacy[view][doing]">
<option value="0"<?=$sels['view']['doing']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['doing']['1']?>>仅好友可见</option>
</select>
</td>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">
本隐私设置仅在其他用户查看您主页时有效；
<br>在全站的记录列表中可能会出现您的记录。
</td>
</tr>
<tr>
<th>日志</th>
<td><select name="privacy[view][blog]">
<option value="0"<?=$sels['view']['blog']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['blog']['1']?>>仅好友可见</option>
</select>
</td>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">本隐私设置仅在其他用户查看您主页时有效；
<br>相关浏览权限需要在每篇日志中单独设置方可完全生效。
</td>
</tr>
<tr>
<th>相册</th>
<td><select name="privacy[view][album]">
<option value="0"<?=$sels['view']['album']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['album']['1']?>>仅好友可见</option>
</select>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">本隐私设置仅在其他用户查看您主页时有效；
<br>相关浏览权限需要在每个相册中单独设置方可完全生效。</td>
</tr>
<tr>
<th>分享</th>
<td><select name="privacy[view][share]">
<option value="0"<?=$sels['view']['share']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['share']['1']?>>仅好友可见</option>
</select></td>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">
本隐私设置仅在其他用户查看您主页时有效；
<br>在全站的分享列表中可能会出现您的分享。
</td>
</tr>
<tr>
<th>活动</th>
<td><select name="privacy[view][event]">
<option value="0"<?=$sels['view']['event']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['event']['1']?>>仅好友可见</option>
</select></td>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">
本隐私设置仅在其他用户查看您主页时有效；
</td>
</tr>
<tr>
<th>投票</th>
<td><select name="privacy[view][poll]">
<option value="0"<?=$sels['view']['poll']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['poll']['1']?>>仅好友可见</option>
</select></td>
</tr>
<tr>
<th>&nbsp;</th>
<td class="gray">
本隐私设置仅在其他用户查看您主页时有效；
</td>
</tr>
<tr>
<th>群组</th>
<td><select name="privacy[view][mtag]">
<option value="0"<?=$sels['view']['mtag']['0']?>>全站用户可见</option>
<option value="1"<?=$sels['view']['mtag']['1']?>>仅好友可见</option>
<option value="2"<?=$sels['view']['mtag']['2']?>>仅自己可见</option>
</select></td>
</tr>
<?php if($_SCONFIG['videophoto'] && $space['videostatus']) { ?>
<tr>
<th></th>
<td><img src="image/videophoto.gif" align="absmiddle"> 你已经通过视频认证，对于没有通过视频认证的用户，你可以设置以下权限：</td>
</tr>
<tr>
<th>查看我的认证照片</th>
<td><select name="privacy[view][videoviewphoto]">
<option value="0"<?=$sels['view']['videoviewphoto']['0']?>>站点默认设置</option>
<option value="1"<?=$sels['view']['videoviewphoto']['1']?>>允许</option>
<option value="2"<?=$sels['view']['videoviewphoto']['2']?>>禁止</option>
</select></td>
</tr>
<tr>
<th>向我申请好友</th>
<td><select name="privacy[view][videofriend]">
<option value="0"<?=$sels['view']['videofriend']['0']?>>站点默认设置</option>
<option value="1"<?=$sels['view']['videofriend']['1']?>>允许</option>
<option value="2"<?=$sels['view']['videofriend']['2']?>>禁止</option>
</select></td>
</tr>
<tr>
<th>向我打招呼</th>
<td><select name="privacy[view][videopoke]">
<option value="0"<?=$sels['view']['videopoke']['0']?>>站点默认设置</option>
<option value="1"<?=$sels['view']['videopoke']['1']?>>允许</option>
<option value="2"<?=$sels['view']['videopoke']['2']?>>禁止</option>
</select></td>
</tr>
<tr>
<th>给我留言</th>
<td><select name="privacy[view][videowall]">
<option value="0"<?=$sels['view']['videowall']['0']?>>站点默认设置</option>
<option value="1"<?=$sels['view']['videowall']['1']?>>允许</option>
<option value="2"<?=$sels['view']['videowall']['2']?>>禁止</option>
</select></td>
</tr>
<tr>
<th>评论我的信息</th>
<td><select name="privacy[view][videocomment]">
<option value="0"<?=$sels['view']['videocomment']['0']?>>站点默认设置</option>
<option value="1"<?=$sels['view']['videocomment']['1']?>>允许</option>
<option value="2"<?=$sels['view']['videocomment']['2']?>>禁止</option>
</select></td>
</tr>
<?php } ?>
<tr>
<th>&nbsp;</th>
<td><input type="submit" name="privacysubmit" value="保存设置" class="submit"></td>
</tr>
</table>

<table cellspacing="0" cellpadding="0" class="formtable" id="feed">
<caption>
<h2>个人动态发布设置</h2>
<p>系统会将您的各项动作反映到个人动态里，方便朋友了解你的动态。<br>你可以控制是否在下列动作发生时，在个人动态里发布相关信息</p>
</caption>
<tr>
<th width="150">&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][doing]" value="1"<?=$sels['feed']['doing']?>>记录</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][blog]" value="1"<?=$sels['feed']['blog']?>>撰写日志</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][upload]" value="1"<?=$sels['feed']['upload']?>>上传图片</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][share]" value="1"<?=$sels['feed']['share']?>>添加分享</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][poll]" value="1"<?=$sels['feed']['poll']?>>发起投票</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][joinpoll]" value="1"<?=$sels['feed']['joinpoll']?>>参与投票</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][thread]" value="1"<?=$sels['feed']['thread']?>>发起话题</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][post]" value="1"<?=$sels['feed']['post']?>>对话题回复</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][mtag]" value="1"<?=$sels['feed']['mtag']?>>加入群组</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][event]" value="1"<?=$sels['feed']['event']?>>发起活动</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][join]" value="1"<?=$sels['feed']['join']?>>参加活动</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][friend]" value="1"<?=$sels['feed']['friend']?>>添加好友</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][comment]" value="1"<?=$sels['feed']['comment']?>>发表评论/留言</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][show]" value="1"<?=$sels['feed']['show']?>>竞价排名</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][credit]" value="1"<?=$sels['feed']['credit']?>>积分消费</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][invite]" value="1"<?=$sels['feed']['invite']?>>邀请好友</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][task]" value="1"<?=$sels['feed']['task']?>>完成任务</td>
</tr>				
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][profile]" value="1"<?=$sels['feed']['profile']?>>更新个人资料</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="checkbox" name="privacy[feed][click]" value="1"<?=$sels['feed']['click']?>>对日志/图片/话题表态</td>
</tr>
<tr>
<th>&nbsp;</th>
<td><input type="submit" name="privacysubmit" value="保存设置" class="submit"></td>
</tr>
</table>

<?php } else { ?>
<?php $iconnames['activity'] = '日志';
			$iconnames['album'] = '相册';
			$iconnames['blog'] = '日志';
			$iconnames['comment'] = '评论';
			$iconnames['blogcomment'] = '日志评论';
			$iconnames['clickblog'] = '日志表态';
			$iconnames['clickpic'] = '图片表态';
			$iconnames['clickthread'] = '话题表态';
			$iconnames['piccomment'] = '图片评论';
			$iconnames['sharecomment'] = '分享评论';
			$iconnames['debate'] = '论坛辩论';
			$iconnames['discuz'] = '论坛';
			$iconnames['doing'] = '记录';
			$iconnames['friend'] = '好友';
			$iconnames['goods'] = '商品';
			$iconnames['mood'] = '心情';
			$iconnames['mtag'] = '群组';
			$iconnames['event'] = '活动';
			$iconnames['eventcomment'] = '活动留言';
			$iconnames['eventmember'] = '活动成员管理';
			$iconnames['eventmemberstatus'] = '活动成员身份';
			$iconnames['network'] = '随便看看';
			$iconnames['poll'] = '论坛投票';
			$iconnames['post'] = '论坛回贴';
			$iconnames['profile'] = '更新个人资料';
			$iconnames['reward'] = '论坛悬赏';
			$iconnames['share'] = '分享';
			$iconnames['sharenotice'] = '分享通知';
			$iconnames['show'] = '排行榜';
			$iconnames['task'] = '有奖任务';
			$iconnames['thread'] = '话题';
			$iconnames['post'] = '话题回复';
			$iconnames['video'] = '视频';
			$iconnames['wall'] = '留言';
			$iconnames['credit'] = '赠送竞价积分';
			$iconnames['poll'] = '投票';
			$iconnames['pollcomment'] = '投票评论';
			$iconnames['pollinvite'] = '投票邀请'; ?>

<table cellspacing="0" cellpadding="0" class="formtable">
<caption>
<h2>筛选规则一：屏蔽指定用户组的动态</h2>
<p>你可以决定屏蔽哪些用户组的动态，屏蔽用户组内的组员所发布的动态都将被屏蔽掉。</p>
</caption>
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<tr>
<th width="150">&nbsp;</th>
<td><input type="checkbox" name="privacy[filter_gid][<?=$key?>]" value="<?=$key?>"<?php if(isset($space['privacy']['filter_gid'][$key])) { ?> checked<?php } ?>>
<?=$value?></td>
</tr>
<?php } } ?>
<tr>
<th>&nbsp;</th>
<td>
<input type="submit" name="privacy2submit" value="保存设置" class="submit">
<br>您可以在自己的<a href="space.php?do=friend">好友列表</a>中，对好友进行分组，并可以对用户组进行改名。
</td>
</tr>
</table>
<br>
<table cellspacing="0" cellpadding="0" class="formtable">
<caption>
<h2>筛选规则二：屏蔽指定好友指定类型的动态</h2>
<p>点击一下首页好友动态列表后面的屏蔽标志，就可以屏蔽指定好友指定类型的动态了。<br>下面列出的是您已经屏蔽的动态类型识别名和好友名，你可以选择是否取消屏蔽。</p>
</caption>
<?php if($icons) { ?>

<tr>
<th width="150">&nbsp;</th>
<td>
<ul>
<?php if(is_array($icons)) { foreach($icons as $key => $icon) { ?>
<?php $uid = $uids[$key];$icon_uid="$icon|$uid"; ?>
<li>
<?php if(is_numeric($icon)) { ?>
<img src="http://appicon.manyou.com/icons/<?=$icon?>" align="absmiddle">
<?php } else { ?>
<img src="image/icon/<?=$icon?>.gif" align="absmiddle">
<?php } ?>
<input type="checkbox" name="privacy[filter_icon][<?=$icon_uid?>]" value="1" checked> 
<span class="type_<?=$icon?>"> <?php if(isset($iconnames[$icon])) { ?><?=$iconnames[$icon]?><?php } else { ?><?=$icon?><?php } ?> (<?php if($users[$uid]) { ?><a href="space.php?uid=<?=$uid?>" target="_blank"><?=$users[$uid]?></a><?php } else { ?>所有好友<?php } ?>)</span>
</li>
<?php } } ?>
</ul>
</td>
</tr>
<tr>
<th>&nbsp;</th>
<td>
<input type="submit" name="privacy2submit" value="保存设置" class="submit">
</td>
</tr>
<?php } else { ?>
<tr>
<th width="150">&nbsp;</th>
<td>现在还没有屏蔽的动态类型</td>
</tr>
<?php } ?>
</table>
<br>
<table cellspacing="0" cellpadding="0" class="formtable">
<caption>
<h2>筛选规则三：屏蔽指定好友指定类型的通知</h2>
<p>点击一下通知列表后面的屏蔽标志，就可以屏蔽指定好友指定类型的通知了。<br>下面列出的是您已经屏蔽的通知类型和好友名，你可以选择是否取消屏蔽。</p>
</caption>
<?php if($types) { ?>

<tr>
<th width="150">&nbsp;</th>
<td>
<ul>
<?php if(is_array($types)) { foreach($types as $key => $type) { ?>
<?php $uid = $uids[$key];$type_uid="$type|$uid"; ?>
<li>
<input type="checkbox" name="privacy[filter_note][<?=$type_uid?>]" value="1" checked>
<span class="type_<?=$type?>"> <?php if(isset($iconnames[$type])) { ?><?=$iconnames[$type]?><?php } else { ?><?=$type?><?php } ?> (<?php if($users[$uid]) { ?><a href="space.php?uid=<?=$uid?>" target="_blank"><?=$users[$uid]?></a><?php } else { ?>所有好友<?php } ?>)</span>
</li>
<?php } } ?>
</ul>
</tr>
<tr>
<th>&nbsp;</th>
<td>
<input type="submit" name="privacy2submit" value="保存设置" class="submit">
</td>
</tr>
<?php } else { ?>
<tr>
<th width="150">&nbsp;</th>
<td>现在还没有屏蔽的通知类型</td>
</tr>
<?php } ?>
</table>
<?php } ?>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>


<?php if(empty($_SGLOBAL['inajax'])) { ?>
<?php if(empty($_TPL['nosidebar'])) { ?>
<?php if($_SGLOBAL['ad']['contentbottom']) { ?><br style="line-height:0;clear:both;"/><div id="ad_contentbottom"><?php adshow('contentbottom'); ?></div><?php } ?>
</div>

<!--/mainarea-->
<div id="bottom"></div>
</div>
<!--/main-->
<?php } ?>

<div id="footer">
<?php if($_TPL['templates']) { ?>
<div class="chostlp" title="切换风格"><img id="chostlp" src="<?=$_TPL['default_template']['icon']?>" onmouseover="showMenu(this.id)" alt="<?=$_TPL['default_template']['name']?>" /></div>
<ul id="chostlp_menu" class="chostlp_drop" style="display: none">
<?php if(is_array($_TPL['templates'])) { foreach($_TPL['templates'] as $value) { ?>
<li><a href="cp.php?ac=common&op=changetpl&name=<?=$value['name']?>" title="<?=$value['name']?>"><img src="<?=$value['icon']?>" alt="<?=$value['name']?>" /></a></li>
<?php } } ?>
</ul>
<?php } ?>

<p class="r_option">
<a href="javascript:;" onclick="window.scrollTo(0,0);" id="a_top" title="TOP"><img src="image/top.gif" alt="" style="padding: 5px 6px 6px;" /></a>
</p>

<?php if($_SGLOBAL['ad']['footer']) { ?>
<p style="padding:5px 0 10px 0;"><?php adshow('footer'); ?></p>
<?php } ?>

<?php if($_SCONFIG['close']) { ?>
<p style="color:blue;font-weight:bold;">
提醒：当前站点处于关闭状态
</p>
<?php } ?>
<p>
<?=$_SCONFIG['sitename']?> - 
<a href="mailto:<?=$_SCONFIG['adminemail']?>">联系我们</a>
<?php if($_SCONFIG['miibeian']) { ?> - <a  href="http://www.miibeian.gov.cn" target="_blank"><?=$_SCONFIG['miibeian']?></a><?php } ?>
</p>
<p>
Powered by <a  href="http://u.discuz.net" target="_blank"><strong>UCenter Home</strong></a> <span title="<?php echo X_RELEASE; ?>"><?php echo X_VER; ?></span>
<?php if(!empty($_SCONFIG['licensed'])) { ?><a  href="http://license.comsenz.com/?pid=7&host=<?=$_SERVER['HTTP_HOST']?>" target="_blank">Licensed</a><?php } ?>
&copy; 2001-2009 <a  href="http://www.comsenz.com" target="_blank">Comsenz Inc.</a>
</p>
<?php if($_SCONFIG['debuginfo']) { ?>
<p><?php echo debuginfo(); ?></p>
<?php } ?>
</div>
</div>
<!--/wrap-->

<?php if($_SGLOBAL['appmenu']) { ?>
<ul id="ucappmenu_menu" class="dropmenu_drop" style="display:none;">
<li><a href="<?=$_SGLOBAL['appmenu']['url']?>" title="<?=$_SGLOBAL['appmenu']['name']?>" target="_blank"><?=$_SGLOBAL['appmenu']['name']?></a></li>
<?php if(is_array($_SGLOBAL['appmenus'])) { foreach($_SGLOBAL['appmenus'] as $value) { ?>
<li><a href="<?=$value['url']?>" title="<?=$value['name']?>" target="_blank"><?=$value['name']?></a></li>
<?php } } ?>
</ul>
<?php } ?>

<?php if($_SGLOBAL['supe_uid']) { ?>
<ul id="membernotemenu_menu" class="dropmenu_drop" style="display:none;">
<?php $member = $_SGLOBAL['member']; ?>
<?php if($member['notenum']) { ?><li><img src="image/icon/notice.gif" width="16" alt="" /> <a href="space.php?do=notice"><strong><?=$member['notenum']?></strong> 个新通知</a></li><?php } ?>
<?php if($member['pokenum']) { ?><li><img src="image/icon/poke.gif" alt="" /> <a href="cp.php?ac=poke"><strong><?=$member['pokenum']?></strong> 个新招呼</a></li><?php } ?>
<?php if($member['addfriendnum']) { ?><li><img src="image/icon/friend.gif" alt="" /> <a href="cp.php?ac=friend&op=request"><strong><?=$member['addfriendnum']?></strong> 个好友请求</a></li><?php } ?>
<?php if($member['mtaginvitenum']) { ?><li><img src="image/icon/mtag.gif" alt="" /> <a href="cp.php?ac=mtag&op=mtaginvite"><strong><?=$member['mtaginvitenum']?></strong> 个群组邀请</a></li><?php } ?>
<?php if($member['eventinvitenum']) { ?><li><img src="image/icon/event.gif" alt="" /> <a href="cp.php?ac=event&op=eventinvite"><strong><?=$member['eventinvitenum']?></strong> 个活动邀请</a></li><?php } ?>
<?php if($member['myinvitenum']) { ?><li><img src="image/icon/userapp.gif" alt="" /> <a href="space.php?do=notice&view=userapp"><strong><?=$member['myinvitenum']?></strong> 个应用消息</a></li><?php } ?>
</ul>
<?php } ?>

<?php if($_SGLOBAL['supe_uid']) { ?>
<?php if(!isset($_SCOOKIE['checkpm'])) { ?>
<script language="javascript"  type="text/javascript" src="cp.php?ac=pm&op=checknewpm&rand=<?=$_SGLOBAL['timestamp']?>"></script>
<?php } ?>
<?php if(!isset($_SCOOKIE['synfriend'])) { ?>
<script language="javascript"  type="text/javascript" src="cp.php?ac=friend&op=syn&rand=<?=$_SGLOBAL['timestamp']?>"></script>
<?php } ?>
<?php } ?>
<?php if(!isset($_SCOOKIE['sendmail'])) { ?>
<script language="javascript"  type="text/javascript" src="do.php?ac=sendmail&rand=<?=$_SGLOBAL['timestamp']?>"></script>
<?php } ?>

<?php if($_SGLOBAL['ad']['couplet']) { ?>
<script language="javascript" type="text/javascript" src="source/script_couplet.js"></script>
<div id="uch_couplet" style="z-index: 10; position: absolute; display:none">
<div id="couplet_left" style="position: absolute; left: 2px; top: 60px; overflow: hidden;">
<div style="position: relative; top: 25px; margin:0.5em;" onMouseOver="this.style.cursor='hand'" onClick="closeBanner('uch_couplet');"><img src="image/advclose.gif"></div>
<?php adshow('couplet'); ?>
</div>
<div id="couplet_rigth" style="position: absolute; right: 2px; top: 60px; overflow: hidden;">
<div style="position: relative; top: 25px; margin:0.5em;" onMouseOver="this.style.cursor='hand'" onClick="closeBanner('uch_couplet');"><img src="image/advclose.gif"></div>
<?php adshow('couplet'); ?>
</div>
<script type="text/javascript">
lsfloatdiv('uch_couplet', 0, 0, '', 0).floatIt();
</script>
</div>
<?php } ?>
<?php if($_SCOOKIE['reward_log']) { ?>
<script type="text/javascript">
showreward();
</script>
<?php } ?>
</body>
</html>
<?php } ?><?php ob_out();?>