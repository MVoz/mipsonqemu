<?php if(!defined('IN_UCHOME')) exit('Access Denied');?><?php subtplcheck('template/default/cp_friend|template/default/header|template/default/space_list|template/default/footer', '1266338076', 'template/default/cp_friend');?><?php if(empty($_SGLOBAL['inajax'])) { ?>
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


<?php if($op == 'syn' || $op == 'find' || $op == 'search' || $op == 'group' || $op == 'request') { ?>
<div class="searchbar floatright">
<form method="get" action="cp.php">
<input name="searchkey" value="" size="15" class="t_input" type="text">
<input name="searchsubmit" value="找人" class="submit" type="submit">
<input type="hidden" name="searchmode" value="1" />
<input type="hidden" name="ac" value="friend" />
<input type="hidden" name="op" value="search" />
</form>
</div>
<h2 class="title"><img src="image/icon/friend.gif">好友</h2>
<div class="tabs_header">
<ul class="tabs">
<li><a href="space.php?uid=<?=$space['uid']?>&do=friend"><span>好友列表</span></a></li>
<li<?=$actives['search']?>><a href="cp.php?ac=friend&op=search"><span>查找好友</span></a></li>
<li<?=$actives['find']?>><a href="cp.php?ac=friend&op=find"><span>可能认识的人</span></a></li>
<?php if(empty($_SCONFIG['closeinvite'])) { ?>
<li><a href="cp.php?ac=invite"><span>邀请好友</span></a></li>
<?php } ?>
<li<?=$actives['request']?>><a href="cp.php?ac=friend&op=request"><span>好友请求</span></a></li>
<li><a href="space.php?do=top"><span>排行榜</span></a></li>
<?php if($op=='group') { ?>
<li<?=$actives['group']?>><a href="cp.php?ac=friend&op=group"><span>好友分组</span></a></li>
<?php } ?>
</ul>
</div>
<?php } ?>

<?php if($op =='ignore') { ?>

<h1>忽略好友</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="__friendform_<?=$uid?>">
<form method="post" id="friendform_<?=$uid?>" name="friendform_<?=$uid?>" action="cp.php?ac=friend&op=ignore&uid=<?=$uid?>&confirm=1">
<p>确定忽略好友关系吗？</p>
<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>">
<?php if($_SGLOBAL['inajax']) { ?>
<input type="hidden" name="friendsubmit" value="true" />
<button name="friendsubmit_btn" type="button" class="submit" value="true" onclick="ajaxpost('friendform_<?=$uid?>', 'friend_delete', 2000)">确定</button>
<?php } else { ?>
<button name="friendsubmit" type="submit" class="submit" value="true">确定</button>
<?php } ?>
</p>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op == 'find') { ?>

<?php if($nearlist) { ?>
<div class="c_form">
<h2 class="l_status title">惊喜，他们就在您的附近</h2>
<ul class="avatar_list">
<?php if(is_array($nearlist)) { foreach($nearlist as $key => $value) { ?>
<li>
<div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>" target="_blank"><?php echo avatar($value[uid],small); ?></a></div>
<p><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"><?=$_SN[$value['uid']]?></a></p>
<p class="gray"><a href="cp.php?ac=friend&op=add&uid=<?=$value['uid']?>" id="a_near_friend_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)" class="addfriend">加为好友</a></p>
</li>
<?php } } ?>
</ul>
</div>
<?php } ?>

<?php if($friendlist) { ?>
<div class="c_form">
<h2 class="l_status title">他们是您的好友的好友，您也可能认识</h2>
<ul class="avatar_list">
<?php if(is_array($friendlist)) { foreach($friendlist as $key => $value) { ?>
<li>
<div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>" target="_blank"><?php echo avatar($value[uid],small); ?></a></div>
<p><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"><?=$_SN[$value['uid']]?></a></p>
<p class="gray"><a href="cp.php?ac=friend&op=add&uid=<?=$value['uid']?>" id="a_friend_friend_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)" class="addfriend">加为好友</a></p>
</li>
<?php } } ?>
</ul>
</div>
<?php } ?>

<?php if($onlinelist) { ?>
<div class="c_form">
<h2 class="l_status title">他们当前正在线，加为好友就可以互动啦</h2>
<ul class="avatar_list">
<?php if(is_array($onlinelist)) { foreach($onlinelist as $key => $value) { ?>
<li>
<div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>" target="_blank"><?php echo avatar($value[uid],small); ?></a></div>
<p><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"><?=$_SN[$value['uid']]?></a></p>
<p class="gray"><a href="cp.php?ac=friend&op=add&uid=<?=$value['uid']?>" id="a_online_friend_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)" class="addfriend">加为好友</a></p>
</li>
<?php } } ?>
</ul>
</div>
<?php } ?>

<?php } elseif($op == 'search') { ?>

<div class="c_form">

<?php if(!empty($_GET['searchsubmit'])) { ?>

<?php if(empty($list)) { ?>
<div class="c_form">没有找到相关用户。<a href="cp.php?ac=friend&op=search">换个搜索条件试试</a></div>
<?php } else { ?>
<div style="padding:0 0 20px 0;">以下是查找到的用户列表(最多显示500个)，您还可以<a href="cp.php?ac=friend&op=search">换个搜索条件试试</a>。</div>
<div class="space_list">
<?php if($list) { ?>
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<table cellspacing="0" cellpadding="0" width="100%">
<tr>
<td width="65"><div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>"><?php echo avatar($value[uid],small); ?></a></div></td>
<td>
<h2>
<?php if($ols[$value['uid']]) { ?><img src="image/online_icon.gif" align="absmiddle"> <?php } ?>
<a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"<?php g_color($value[groupid]); ?>><?=$_SN[$value['uid']]?></a>
<?php if($value['username'] && $_SN[$value['uid']]!=$value['username']) { ?><span class="gray">(<?=$value['username']?>)</span><?php } ?>
<?php g_icon($value[groupid]); ?>
<?php if($value['videostatus']) { ?>
<img src="image/videophoto.gif" align="absmiddle">
<?php } ?>
</h2>
<?php if($value['sex']==2) { ?><p>美女</p><?php } elseif($value['sex']==1) { ?><p>帅哥</p><?php } ?></p>
<p>
<?php if($_GET['view']=='show') { ?>竞价<?php } ?>积分：<?=$value['credit']?> / <?php if($value['experience']) { ?>经验：<?=$value['experience']?> / <?php } ?>人气：<?=$value['viewnum']?> / 好友：<?=$value['friendnum']?></p>
<?php if($value['note']) { ?><?=$value['note']?><?php } ?>
</td>
<td width="100">
<ul class="line_list">
<li><a href="space.php?uid=<?=$value['uid']?>">去串个门</a></li>
<li><a href="cp.php?ac=poke&op=send&uid=<?=$value['uid']?>" id="a_poke_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)" title="打招呼">打个招呼</a></li>
<?php if(isset($value['isfriend']) && !$value['isfriend']) { ?><li><a href="cp.php?ac=friend&op=add&uid=<?=$value['uid']?>" id="a_friend_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)" title="加好友">加为好友</a></li><?php } ?>	
</ul>
</td>
</tr>
</table>
<?php } } ?>
<div class="page"><?=$multi?></div>
<?php } else { ?>
<div class="c_form">没有相关成员。</div>
<?php } ?>
</div>


<?php } ?>

<?php } else { ?>
<table cellspacing="2" cellpadding="2" class="search_table">

<?php if($_GET['all']) { ?>
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td align="right">用户UID：</td><td><input type="text" name="uid" value="" class="t_input"></td></tr>
<tr>
<td align="right" width="100">性别：</td>
<td>
<select id="sex" name="sex">
<option value="0">任意</option>
<option value="1">男</option>
<option value="2">女</option>
</select>
</td>
</tr>
<tr>
<td align="right">婚恋：</td>
<td>
<select id="marry" name="marry">
<option value="0">任意</option>
<option value="1">单身</option>
<option value="2">非单身</option>
</select>
</td>
</tr>
<tr>
<td align="right">年龄段：</td>
<td>
<input type="text" name="startage" value="" size="10" class="t_input" /> ~ <input type="text" name="endage" value="" size="10" class="t_input" />
</td>
</tr>
<?php if($_SCONFIG['videophoto']) { ?>
<tr>
<td align="right">视频认证：</td>
<td>
<input type="checkbox" name="videostatus" value="1">通过视频认证
</td>
</tr>
<?php } ?>
<tr>
<td align="right">上传头像：</td>
<td>
<input type="checkbox" name="avatar" value="1">已经上传头像
</td>
</tr>

<tr>
<td align="right">居住地：</td>
<td id="residecitybox"></td>
</tr>

<tr>
<td align="right">出生地：</td>
<td id="birthcitybox"></td>
</tr>

<script type="text/javascript" src="source/script_city.js"></script>
<script type="text/javascript">
<!--
showprovince('resideprovince', 'residecity', '', 'residecitybox');
showcity('residecity', '', 'resideprovince', 'residecitybox');
showprovince('birthprovince', 'birthcity', '', 'birthcitybox');
showcity('birthcity', '', 'birthprovince', 'birthcitybox');
//-->
</script>	

<tr>
<td align="right">生日：</td>
<td>
<select id="birthyear" name="birthyear" onchange="showbirthday();">
<option value="0">&nbsp;</option>
<?=$birthyeayhtml?>
</select> 年 
<select id="birthmonth" name="birthmonth" onchange="showbirthday();">
<option value="0">&nbsp;</option>
<?=$birthmonthhtml?>
</select> 月 
<select id="birthday" name="birthday">
<option value="0">&nbsp;</option>
<?=$birthdayhtml?>
</select> 日
</td>
</tr>

<tr><td align="right">学校：</td><td><input type="text" name="title" value="" class="t_input"> <select name="startyear">
<option value="">入学年份</option>
<?=$yearhtml?>
</select></td></tr>
<tr><td align="right">班级或院系：</td><td><input type="text" name="subtitle" value="" class="t_input"></td></tr>

<tr><td align="right">公司或机构：</td><td><input type="text" name="title" value="" class="t_input"></td></tr>
<tr><td align="right">部门：</td><td><input type="text" name="subtitle" value="" class="t_input"></td></tr>


<tr>
<td align="right">血型：</td>
<td>
<select id="blood" name="blood">
<option value="">任意</option>
<?=$bloodhtml?>
</select>
</td>
</tr>


<tr>
<td align="right">QQ：</td>
<td>
<input type="text" name="qq" value="" class="t_input" />
</td>
</tr>
<tr>
<td align="right">MSN：</td>
<td>
<input type="text" name="msn" value="" class="t_input" />
</td>
</tr>

<?php if(is_array($fields)) { foreach($fields as $fkey => $fvalue) { ?>
<?php if($fvalue['allowsearch']) { ?>
<tr>
<td align="right"><?=$fvalue['title']?>：</td>
<td>
<?=$fvalue['html']?>
</td>
</tr>
<?php } ?>
<?php } } ?>

<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="all">
</form>	
</td></tr>
<?php } else { ?>
<tr>
<th style="border-top: none;"><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('sex');">查找男女朋友</a></th>
</tr>
<tbody id="s_sex" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr>
<td align="right" width="100">性别：</td>
<td>
<select id="sex" name="sex">
<option value="0">任意</option>
<option value="1"<?=$sexarr['1']?>>男</option>
<option value="2"<?=$sexarr['2']?>>女</option>
</select>
</td>
</tr>
<tr>
<td align="right">婚恋：</td>
<td>
<select id="marry" name="marry">
<option value="0">任意</option>
<option value="1"<?=$marryarr['1']?>>单身</option>
<option value="2"<?=$marryarr['2']?>>非单身</option>
</select>
</td>
</tr>
<tr>
<td align="right">年龄段：</td>
<td>
<input type="text" name="startage" value="" size="10" class="t_input" /> ~ <input type="text" name="endage" value="" size="10" class="t_input" />
</td>
</tr>
<?php if($_SCONFIG['videophoto']) { ?>
<tr>
<td align="right" width="100">视频认证：</td>
<td>
<input type="checkbox" name="videostatus" value="1">通过视频认证
</td>
</tr>
<?php } ?>
<tr>
<td align="right" width="100">上传头像：</td>
<td>
<input type="checkbox" name="avatar" value="1">已经上传头像
</td>
</tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="base">
</form>
</td>
</tr>
</tbody>


<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('reside');">查找同城的人</a></th>
</tr>
<tbody id="s_reside" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr>
<td align="right" width="150">居住地：</td>
<td id="residecitybox"></td>
</tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<script type="text/javascript" src="source/script_city.js"></script>
<script type="text/javascript">
<!--
showprovince('resideprovince', 'residecity', '<?=$space['resideprovince']?>', 'residecitybox');
showcity('residecity', '<?=$space['residecity']?>', 'resideprovince', 'residecitybox');
//-->
</script>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="base">
</form>
</td>
</tr>
</tbody>


<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('birth');">查找老乡</a></th>
</tr>
<tbody id="s_birth" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr>
<td align="right" width="150">出生地：</td>
<td id="birthcitybox"></td>
</tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<script type="text/javascript" src="source/script_city.js"></script>
<script type="text/javascript">
<!--
showprovince('birthprovince', 'birthcity', '<?=$space['birthprovince']?>', 'birthcitybox');
showcity('birthcity', '<?=$space['birthcity']?>', 'birthprovince', 'birthcitybox');
//-->
</script>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="base">
</form>
</td>
</tr>
</tbody>


<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('birthyear');">查找同年同月同日生的人</a></th>
</tr>
<tbody id="s_birthyear" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr>
<td align="right" width="150">生日：</td>
<td>
<select id="birthyear" name="birthyear" onchange="showbirthday();">
<option value="0">&nbsp;</option>
<?=$birthyeayhtml?>
</select> 年 
<select id="birthmonth" name="birthmonth" onchange="showbirthday();">
<option value="0">&nbsp;</option>
<?=$birthmonthhtml?>
</select> 月 
<select id="birthday" name="birthday">
<option value="0">&nbsp;</option>
<?=$birthdayhtml?>
</select> 日
</td>
</tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="base">
</form>
</td>
</tr>
</tbody>

<tr>
<th>
<img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('edu');">查找你的同学</a>
</th>
</tr>
<tbody id="s_edu" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr><td align="right" width="150">学校：</td><td><input type="text" name="title" value="" class="t_input"> <select name="startyear">
<option value="">入学年份</option>
<?=$yearhtml?>
</select></td></tr>
<tr><td align="right">班级或院系：</td><td><input type="text" name="subtitle" value="" class="t_input"></td></tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="edu">
</form>
</td>
</tr>
</tbody>

<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('work');">查找你的同事</a></th>
</tr>
<tbody id="s_work" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr><td align="right" width="150">公司或机构：</td><td><input type="text" name="title" value="" class="t_input"></td></tr>
<tr><td align="right">部门：</td><td><input type="text" name="subtitle" value="" class="t_input"></td></tr>
<tr><td align="right">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="work">
</form>
</td>
</tr>
</tbody>


<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="javascript:;" onclick="showtbody('name');">精确查找</a></th>
</tr>
<tbody id="s_name" style="display:none;">
<tr>
<td>
<form action="cp.php" method="get">
<table>
<tr><td align="right" width="150">姓名：</td><td><input type="text" name="name" value="" class="t_input"></td></tr>
<tr><td align="right">用户名：</td><td><input type="text" name="username" value="" class="t_input"></td></tr>
<tr><td align="right">用户UID：</td><td><input type="text" name="uid" value="" class="t_input"></td></tr>
<tr><td></td><td><input type="submit" name="searchsubmit" value="查找" class="submit"></td></tr>
</table>
<input type="hidden" name="ac" value="friend">
<input type="hidden" name="op" value="search">
<input type="hidden" name="type" value="base">
</form>
</td>
</tr>
</tbody>

<tr>
<th><img src="image/search.gif" align="absmiddle">
<a href="cp.php?ac=friend&op=search&all=yes">高级方式查找</a></th>
</tr>
<?php } ?>

</table>
<?php } ?>
</div>

<script>
function showtbody(id) {
var obj = $('s_'+id);
if(obj.style.display == 'none') {
obj.style.display = '';
} else {
obj.style.display = 'none';
}
}
<?php if($_GET['view']) { ?>showtbody('<?=$_GET['view']?>');<?php } ?>
</script>

<?php } elseif($op=='changenum') { ?>

<h1>好友热度</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="__changenumform_<?=$uid?>">
<form method="post" id="changenumform_<?=$uid?>" name="changenumform_<?=$uid?>" action="cp.php?ac=friend&op=changenum&uid=<?=$uid?>">
<p>调整好友的热度</p>
<p>
新的热度：<input type="text" name="num" value="<?=$friend['num']?>" size="5"> (0~9999之间的一个数字）
</p>
<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>">
<button name="changenumsubmit" type="submit" class="submit" value="true">确定</button>
</p>

<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op=='changegroup') { ?>

<h1>好友分组</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="__changegroupform_<?=$uid?>">
<form method="post" id="changegroupform_<?=$uid?>" name="changegroupform_<?=$uid?>" action="cp.php?ac=friend&op=changegroup&uid=<?=$uid?>">
<p>设置好友分组</p>
<table cellspacing="2" cellpadding="2"><tr>
<?php $i=0; ?>
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<td><input type="radio" name="group" value="<?=$key?>"<?=$groupselect[$key]?>> <?=$value?></td>
<?php if($i%2==1) { ?></tr><tr><?php } ?>
<?php $i++; ?>
<?php } } ?>
</tr></table>

<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>">
<?php if($_SGLOBAL['inajax']) { ?>
<input type="hidden" name="changegroupsubmit" value="true" />
<button name="changegroupsubmit_btn" type="button" class="submit" value="true" onclick="ajaxpost('changegroupform_<?=$uid?>', 'friend_changegroup', 2000)">确定</button>
<?php } else { ?>
<button name="changegroupsubmit" type="submit" class="submit" value="true">确定</button>
<?php } ?>
</p>

<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op=='group') { ?>

<div class="h_status">
对选定的好友进行分组，热度表示的是你跟好友互动的次数。
</div>

<div id="content" style="width: 640px;">
<form method="post" action="cp.php?ac=friend&op=group&ref">
<?php if($list) { ?>
<div class="thumb_list" id="friend_ul">
<ul>
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<li>
<div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>"><?php echo avatar($value[uid],small); ?></a></div>
<div class="thumbTitle"><input type="checkbox" name="fuids[]" value="<?=$value['uid']?>" /><a href="space.php?uid=<?=$value['uid']?>"><?=$_SN[$value['uid']]?></a></div>
<div class="gray">热度：<?=$value['num']?></div>
<div class="gray"><?=$value['group']?></div>
</li>
<?php } } ?>
</ul>
</div>
<div class="page"><?=$multi?></div>
<div style="padding:20px 0 0 0;">
<input type="checkbox" id="chkall" name="chkall" onclick="checkAll(this.form, 'fuids')" /><label for="chkall">全选</label></td>
设置用户组：<select name="group">
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<option value="<?=$key?>"><?=$value?></option>
<?php } } ?>
</select>
<input type="submit" name="btnsubmit" value="确定" class="submit" />
</div>
<?php } else { ?>
<div class="c_form">
没有相关用户列表。
</div>
<?php } ?>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
<input type="hidden" name="groupsubmin" value="true" />
</form>
</div>

<div id="sidebar" style="width: 150px;">
<div class="cat">
<h3>好友分组</h3>
<ul class="post_list line_list">
<li<?php if(!isset($_GET['group'])) { ?> class="current"<?php } ?>><a href="cp.php?ac=friend&op=group">全部好友</a></li>
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<li<?php if(isset($_GET['group']) && $_GET['group']==$key) { ?> class="current"<?php } ?>><a href="cp.php?ac=friend&op=group&group=<?=$key?>"><?=$value?></a></li>
<?php } } ?>
</ul>
</div>
</div>

<?php } elseif($op=='groupname') { ?>

<h1>好友组</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="__groupnameform_<?=$group?>">
<form method="post" id="groupnameform_<?=$group?>" name="groupnameform_<?=$group?>" action="cp.php?ac=friend&op=groupname&group=<?=$group?>">
<p>设置新好友分组名</p>
<div class="c_form">
新名称：<input type="text" name="groupname" value="<?=$groups[$group]?>" size="15" class="t_input">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>">
<?php if($_SGLOBAL['inajax']) { ?>
<input type="hidden" name="groupnamesubmit" value="true" />
<input type="button" name="groupnamesubmit_btn" value="确定" class="submit" onclick="ajaxpost('groupnameform_<?=$group?>', 'friend_changegroupname', 2000)" />
<?php } else { ?>
<input type="submit" name="groupnamesubmit" value="确定" class="submit" />
<?php } ?>
</div>

<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>


<?php } elseif($op=='groupignore') { ?>

<h1>调整用户组动态</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="<?=$group?>">
<form method="post" id="groupignoreform" name="groupignoreform" action="cp.php?ac=friend&op=groupignore&group=<?=$group?>">
<?php if(!isset($space['privacy']['filter_gid'][$group])) { ?>
<p>在首页不显示该用户组的好友动态</p>
<?php } else { ?>
<p>在首页显示该用户组的好友动态</p>
<?php } ?>
<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>">
<?php if($_SGLOBAL['inajax']) { ?>
<input type="hidden" name="groupignoresubmit" value="true" />
<button name="groupignoresubmit_btn" type="submit" class="submit" value="true">确定</button>
<?php } else { ?>
<button name="groupignoresubmit" type="submit" class="submit" value="true">确定</button>
<?php } ?>
</p>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op=='request') { ?>

<div class="l_status">
<div class="r_option">
<a href="cp.php?ac=friend&op=ignore&confirm=1&key=<?=$space['key']?>" onclick="return confirm('您确定要忽略所有的好友申请吗？');">忽略所有好友申请(慎用)</a>
 | <a href="cp.php?ac=friend&op=addconfirm&key=<?=$space['key']?>">批准全部申请</a>
</div>
<span id="add_friend_div">请选定好友的申请进行批准或忽略</span>
<?php if($maxfriendnum) { ?>
(最多可以添加 <?=$maxfriendnum?> 个好友)
<p>
<?php if($_SGLOBAL['magic']['friendnum']) { ?>
<img src="image/magic/friendnum.small.gif" class="magicicon" />
<a id="a_magic_friendnum" href="magic.php?mid=friendnum" onclick="ajaxmenu(event, this.id, 1)">我要扩容好友数</a>
(您可以购买道具“<?=$_SGLOBAL['magic']['friendnum']?>”来扩容，让自己可以添加更多的好友。)
<?php } ?>
</p>
<?php } ?>
</div>
<?php if($list) { ?>
<div class="thumb_list" id="friend_ul">
<table cellspacing="6" cellpadding="0">
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<tbody id="friend_tbody_<?=$value['uid']?>">
<tr>
<td class="thumb <?php if($ols[$value['uid']]) { ?>online<?php } ?>">
<table cellpadding="0" cellspacing="0">
<tr>
<td class="image">
<div class="ar_r_t"><div class="ar_l_t"><div class="ar_r_b"><div class="ar_l_b">
<a href="space.php?uid=<?=$value['uid']?>" class="avatarlink"><?php echo avatar($value[uid],middle); ?></a>
</div></div></div></div>
</td>
<td>
<h6 class="l_status">
<a href="space.php?uid=<?=$value['uid']?>"><?=$_SN[$value['uid']]?></a>
<?php if($value['videostatus']) { ?>
<img src="image/videophoto.gif" align="absmiddle"> <span class="gray">已通过视频认证</span>
<?php } ?>
</h6>
<div id="friend_<?=$value['uid']?>">
<?php if($value['note']) { ?><div class="quote"><span id="quote" class="q"><?=$value['note']?></span></div><?php } ?>
<p><?php echo sgmdate('m-d H:i',$value[dateline],1); ?></p>
<?php if($value['cfcount']) { ?><p><a href="cp.php?ac=friend&op=getcfriend&fuid=<?=$value['cfriend']?>" id="a_cfriend_<?=$key?>" onclick="ajaxmenu(event, this.id, 1)">你们有 <?=$value['cfcount']?> 个共同好友</a></p><?php } ?>
<p style="margin-top:1em;">
<a href="cp.php?ac=friend&op=add&uid=<?=$value['uid']?>" id="afr_<?=$value['uid']?>" onclick="ajaxmenu(event, this.id, 1)" class="submit a">批准申请</a>
<a href="cp.php?ac=friend&op=ignore&uid=<?=$value['uid']?>&confirm=1" id="afi_<?=$value['uid']?>" onclick="ajaxmenu(event, this.id, 1)" class="button a">忽略</a>
</p>
</div>
</td>
</tr>
<tbody id="cf_<?=$value['uid']?>"></tbody>
</table>
</td>
</tr>
</tbody>
<?php } } ?>
</table>
</div>
<div class="page"><?=$multi?></div>
<?php } else { ?>
<div class="c_form">
没有新的好友请求。
</div>
<?php } ?>

<?php } elseif($op=='getcfriend') { ?>


<h1>共同好友</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="cfriend">
<div class="h_status">最多显示15位共同的好友</div>
<ul class="avatar_list">
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<li>
<div class="avatar48"><a href="space.php?uid=<?=$value['uid']?>"><?php echo avatar($value[uid],small); ?></a></div>
<p><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"><?=$_SN[$value['uid']]?></a></p>
</li>
<?php } } ?>
</ul>
</div>

<?php } elseif($op=='add') { ?>

<h1>加好友</h1>
<a href="javascript:hideMenu();" title="关闭" class="float_del">关闭</a>
<div class="popupmenu_inner" id="__addform_<?=$tospace['uid']?>">
<form method="post" id="addform_<?=$tospace['uid']?>" name="addform_<?=$tospace['uid']?>" action="cp.php?ac=friend&op=add&uid=<?=$tospace['uid']?>">
<table cellspacing="0" cellpadding="3">
<tr>
<th width="52"><a href="space.php?uid=<?=$tospace['uid']?>"><?php echo avatar($tospace[uid],small); ?></th>
<td>加 <strong><?=$_SN[$tospace['uid']]?></strong> 为好友，附言：<br />
<input type="text" name="note" value="" size="20" class="t_input" style="width: 300px;"  onkeydown="ctrlEnter(event, 'addsubmit_btn', 1);" />
<p class="gray">(附言为可选，<?=$_SN[$tospace['uid']]?> 会看到这条附言，最多50个字符)</p>
</td>
</tr>
<tr>
<th>&nbsp;</th>
<td>
分组: <select name="gid">
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<option value="<?=$key?>"><?=$value?></option>
<?php } } ?>
</select>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="addsubmit" value="true" />
<?php if($_SGLOBAL['inajax']) { ?>
<input type="button" name="addsubmit_btn" id="addsubmit_btn" value="确定" class="submit" onclick="ajaxpost('addform_<?=$tospace['uid']?>','',2000)" />
<?php } else { ?>
<input type="submit" name="addsubmit_btn" id="addsubmit_btn" value="确定" class="submit" />
<?php } ?>
</td>
</table>

<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>


<?php } elseif($op=='add2') { ?>

<h1>批准请求</h1>
<a href="javascript:hideMenu();" title="关闭" class="float_del">关闭</a>
<div class="popupmenu_inner" id="__addratifyform_<?=$tospace['uid']?>">
<form method="post" id="addratifyform_<?=$tospace['uid']?>" name="addratifyform_<?=$tospace['uid']?>" action="cp.php?ac=friend&op=add&uid=<?=$tospace['uid']?>">
<table cellspacing="0" cellpadding="3">
<tr>
<th width="52"><a href="space.php?uid=<?=$tospace['uid']?>"><?php echo avatar($tospace[uid],small); ?></th>
<td>
<div class="l_status">批准 <strong><?=$_SN[$tospace['uid']]?></strong> 的好友请求，并分组：</div>
<table cellspacing="2" cellpadding="2"><tr>
<?php $i=0; ?>
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<td><input type="radio" name="gid" id="group_<?=$key?>" value="<?=$key?>"<?=$groupselect[$key]?>> <label for="group_<?=$key?>"><?=$value?></label></td>
<?php if($i%2==1) { ?></tr><tr><?php } ?>
<?php $i++; ?>
<?php } } ?>
</tr></table>

<p>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<?php if($_SGLOBAL['inajax']) { ?>
<input type="hidden" name="add2submit" value="true" />
<input type="button" name="add2submit_btn" value="批准" class="submit" onclick="ajaxpost('addratifyform_<?=$tospace['uid']?>', 'myfriend_post', 2000)" />
<?php } else { ?>
<input type="submit" name="add2submit" value="批准" class="submit" />
<?php } ?>
</p>
</td>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } ?>
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
<?php } ?>
<?php ob_out();?>