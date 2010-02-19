<?php if(!defined('IN_UCHOME')) exit('Access Denied');?><?php subtplcheck('template/default/cp_credit|template/default/header|template/default/cp_header|template/default/footer', '1266338045', 'template/default/cp_credit');?><?php if(empty($_SGLOBAL['inajax'])) { ?>
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
<a href="cp.php?ac=credit"<?=$cat_actives['base']?>>我的积分</a><span class="pipe">|</span>
<a href="cp.php?ac=credit&op=rule"<?=$cat_actives['rule']?>>积分规则</a><span class="pipe">|</span>
<a href="cp.php?ac=credit&op=usergroup"<?=$cat_actives['usergroup']?>>用户组规则</a><span class="pipe">|</span>
<a href="cp.php?ac=credit&op=exchange"<?=$cat_actives['exchange']?>>积分兑换</a>
</div>

<?php $_TPL['cycletype'] = array(
		'0' => '一次性',
		'1' => '每天',
		'2' => '整点',
		'3' => '间隔分钟',
		'4' => '不限周期'
	); ?>

<div class="c_form">
<?php if(empty($_GET['op'])) { ?>	

<table cellspacing="0" cellpadding="0" class="formtable">
<tr>
<th width="150">经验值:</th>
<td><span style="color:green;font-size:14px;"><?=$space['experience']?></span> <?php echo getstar($space[experience]); ?></td>
</tr>
<tr><th width="150">&nbsp;</th><td class="gray">
经验每满 <strong><?=$_SCONFIG['starcredit']?></strong> 个，就会增加一个图标 <img src="image/star_level1.gif" align="absmiddle"><br>
每满 <strong><?=$_SCONFIG['starlevelnum']?></strong> 个当前图标就升级为 <strong>1</strong> 个高一等级图标<br>
图标等级由低到高为：<?php for($i=1;$i<11;$i++){ ?><img src="image/star_level<?=$i?>.gif"><?php } ?></td></tr>
<tr>
<th width="150">用户组:</th>
<td>
<span<?php g_color($space[groupid]); ?>><?=$space['grouptitle']?></span>
<?php g_icon($space[groupid]); ?>
</td>
</tr>
<tr>
<th width="150">积分数:</th>
<td>
<img src="image/credit.gif">
<span style="color:red;font-size:14px;"><?=$space['credit']?></span>
<span class="gray">(<a href="space.php?do=top&view=credit">查看排名</a>)</span>
</td>
</tr>
<tr><th>访问量:</th>
<td><?=$space['viewnum']?> 
<span class="gray">(<a href="space.php?do=top&view=viewnum">查看排名</a>)</span>
</td></tr>
<tr><th>创建时间:</th><td><?php echo sgmdate('Y-m-d',$space[dateline],1); ?></td></tr>
<tr><th>上次登录:</th><td><?php echo sgmdate('Y-m-d',$space[lastlogin],1); ?></td></tr>
<tr><th>最后更新:</th><td><?php echo sgmdate('Y-m-d',$space[updatetime],1); ?></td></tr>

<tr>
<th>空间容量:</th>
<td> 最大空间 <?=$maxattachsize?>, 已用 <?=$space['attachsize']?> (<?=$percent?>%)</td>
</tr>
<?php if($space['haveattachsize']) { ?><tr><th>剩余空间:</th><td><?=$space['haveattachsize']?></td></tr><?php } ?>
</table>
<br>

<table cellspacing="0" cellpadding="0" class="listtable">
<caption>
<h2>获得积分历史</h2>
<p>显示你获得积分的动作列表，奖励积分值与经验值只记录最后一次获得的奖励</p>
</caption>
<thead>
<tr class="title">
<td>动作名称</td>
<td align="center">总次数</td>
<td align="center">周期次数</td>
<td align="center">单次积分</td>
<td align="center">单次经验值</td>
<td align="center">最后奖励时间</td>
</tr>
</thead>
<?php if($list) { ?>
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<tr<?php if($key%2==0) { ?> class="line"<?php } ?>>
<td><a href="cp.php?ac=credit&op=rule&rid=<?=$value['rid']?>"><?=$value['rulename']?></a></td>
<td align="center"><?=$value['total']?></td>
<td align="center"><?=$value['cyclenum']?></td>
<td align="center"><?=$value['credit']?></td>
<td align="center"><?=$value['experience']?></td>
<td align="center"><?php echo sgmdate('m-d H:i',$value[dateline]); ?></td>
</tr>
<?php } } ?>
<?php } else { ?>
<tr>
<td colspan="6">暂时没有获务任何积分</td>
</tr>
<?php } ?>
<?php if($multi) { ?>
<tr>
<td colspan="6"><div class="page"><?=$multi?></div></td>
</tr>
<?php } ?>
</table>

<?php } elseif($_GET['op'] == 'exchange') { ?>

<form method="post" action="cp.php?ac=credit&op=exchange">
<table cellspacing="0" cellpadding="0" class="formtable">
<caption>
<h2>积分兑换</h2>
<p>您可以将自己的积分兑换到本站其他的应用（比如论坛）里面。</p>
</caption>
<tr><th width="150">目前您的积分数:</th><td> <?=$space['credit']?></td></tr>
<tr>
<th><label for="password">密码</label>:</th>
<td><input type="password" name="password" class="t_input" /></td>
</tr>
<tr>
<th>支出积分:</th>
<td><input type="text" id="amount" name="amount" value="0" class="t_input" onkeyup="calcredit();" /></td>
</tr>
<tr>
<th>兑换成:</th>
<td>
<input type="text" id="desamount" value="0" class="t_input" disabled />&nbsp;&nbsp;
<select name="tocredits" id="tocredits" onChange="calcredit();">
<?php if(is_array($_CACHE['creditsettings'])) { foreach($_CACHE['creditsettings'] as $id => $ecredits) { ?>
<?php if($ecredits['ratio']) { ?>
<option value="<?=$id?>" unit="<?=$ecredits['unit']?>" title="<?=$ecredits['title']?>" ratio="<?=$ecredits['ratio']?>"><?=$ecredits['title']?></option>
<?php } ?>
<?php } } ?>
</select>
</td>
</tr>
<tr>
<th>兑换比率:</th>
<td><span class="bold">1</span>&nbsp;<span id="orgcreditunit">积分</span><span id="orgcredittitle"></span>&nbsp;兑换&nbsp;<span class="bold" id="descreditamount"></span>&nbsp;<span id="descreditunit"></span><span id="descredittitle"></span></td>
</tr>
<tr><th>&nbsp;</th><td><input type="submit" name="exchangesubmit" value="兑换积分" class="submit"></td></tr>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
<script type="text/javascript">
function calcredit() {
tocredit = $('tocredits')[$('tocredits').selectedIndex];
$('descreditunit').innerHTML = tocredit.getAttribute('unit');
$('descredittitle').innerHTML = tocredit.getAttribute('title');
$('descreditamount').innerHTML = Math.round(1/tocredit.getAttribute('ratio') * 100) / 100;
$('amount').value = $('amount').value.toInt();
if($('amount').value != 0) {
$('desamount').value = Math.floor(1/tocredit.getAttribute('ratio') * $('amount').value);
} else {
$('desamount').value = $('amount').value;
}
}
String.prototype.toInt = function() {
var s = parseInt(this);
return isNaN(s) ? 0 : s;
}
calcredit();
</script>

<?php } elseif($_GET['op'] == 'rule') { ?>

<?php if($list) { ?>
<table cellspacing="0" cellpadding="0" class="listtable">
<caption>
<h2>积分奖励规则</h2>
<p>进行以下事件动作，会得到积分奖励。不过，在一个周期内，您最多得到的奖励次数有限制。</p>
</caption>
<tr class="title">
<td>动作名称</td>
<td align="center">周期范围</td>
<td align="center">周期内最多奖励次数</td>
<td align="center" width="100">单次奖励分值</td>
</tr>
<?php if(is_array($list)) { foreach($list as $key => $value) { ?>
<tr<?php if($key%2==0) { ?> class="line"<?php } ?>>
<td><?=$value['rulename']?></td>
<td align="center"><?=$_TPL['cycletype'][$value['cycletype']]?></td>
<td align="center"><?php if($value['rewardnum']) { ?><?=$value['rewardnum']?><?php } else { ?>不限次数<?php } ?></td>
<td align="center"><?=$value['credit']?></td>
</tr>
<?php } } ?>
</table>
<?php } ?>

<?php if($list2) { ?>
<br>
<table cellspacing="0" cellpadding="0" class="listtable">
<caption>
<h2>积分扣减规则</h2>
<p>以下事件动作发生时，会扣减积分。其中，自己发布的信息自己删除，不扣减积分，被管理员删除才会扣减积分。</p>
</caption>
<tr class="title">
<th>动作名称</th>
<th align="center">单次扣减分值</th>
</tr>
<?php if(is_array($list2)) { foreach($list2 as $key => $value) { ?>
<tr<?php if($key%2==0) { ?> class="line"<?php } ?>>
<td><?=$value['rulename']?></td>
<td align="center" width="100"><?=$value['credit']?></td>
</tr>
<?php } } ?>
</table>
<?php } ?>

<?php } elseif($_GET['op'] == 'usergroup') { ?>

<table cellspacing="0" cellpadding="0" class="listtable">
<caption>
<h2>普通用户组</h2>
<p>随着您的经验值的提高，您的用户组所拥有的权限也会越多。</p>
</caption>
<tr class="title">
<th width="150">用户组名</th>
<td>经验值范围</td>
</tr>
<?php if(is_array($groups)) { foreach($groups as $value) { ?>
<tr>
<th><span<?php g_color($value[gid]); ?>><?=$value['grouptitle']?></span><?php g_icon($value[gid]); ?></th>
<td><?=$value['explower']?> ~ <?=$value['exphigher']?></td>
</tr>
<?php } } ?>
</table>

<table cellspacing="0" cellpadding="0" class="listtable">
<caption>
<h2>特殊用户组</h2>
<p>不受经验值限制。</p>
</caption>
<tr class="title">
<th width="150">用户组名</th>
<td>经验值范围</td>
</tr>
<?php if(is_array($s_groups)) { foreach($s_groups as $value) { ?>
<tr>
<th><span<?php g_color($value[gid]); ?>><?=$value['grouptitle']?></span><?php g_icon($value[gid]); ?></th>
<td>-</td>
</tr>
<?php } } ?>
</table>

<?php } ?>

</div>

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