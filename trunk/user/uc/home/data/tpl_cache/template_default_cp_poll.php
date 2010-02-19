<?php if(!defined('IN_UCHOME')) exit('Access Denied');?><?php subtplcheck('template/default/cp_poll|template/default/header|template/default/cp_topic_menu|template/default/footer|template/default/space_topic_inc', '1266316214', 'template/default/cp_poll');?><?php if(empty($_SGLOBAL['inajax'])) { ?>
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


<?php if($op == 'addopt') { ?>

<h1>添加投票项</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="<?=$pid?>">
<form id="add_option_<?=$pid?>" name="add_option_<?=$pid?>" method="post" action="cp.php?ac=poll&op=addopt&pid=<?=$pid?>">
<div id="__add_option_<?=$pid?>">
<table>
<tr>
<td>

<label for="newoption">请输入新增的投票候选项：</label><br />
<input type="text" class="t_input" id="newoption" name="newoption" value="" size="50"/>
</td>
</tr>
<tr>
<td>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="addopt" value="true" />
<input type="submit" name="addopt_btn" id="addopt_btn" value="提交" class="submit" />
</td>
</tr>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</div>
</form>
</div>

<?php } elseif($op=='delete') { ?>

<h1>删除投票</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner">
<form method="post" action="cp.php?ac=poll&op=delete&pid=<?=$pid?>">
<p>确定删除指定的投票吗？</p>
<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="deletesubmit" value="true" />
<input type="submit" name="btnsubmit" value="确定" class="submit" />
</p>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op=='endreward') { ?>

<h1>终止悬赏</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner">
<form method="post" action="cp.php?ac=poll&op=endreward&pid=<?=$pid?>">
<p>终止悬赏后，剩余的积分打回您的帐户<br>确定继续吗？</p>
<p class="btn_line">
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="endrewardsubmit" value="true" />
<input type="submit" name="btnsubmit" value="确定" class="submit" />
</p>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op == 'edithot') { ?>

<h1>调整热度</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner">
<form method="post" action="cp.php?ac=poll&op=edithot&pid=<?=$pid?>">
<p class="btn_line">
新的热度：<input type="text" name="hot" value="<?=$poll['hot']?>" size="5"> 
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="hotsubmit" value="true" />
<input type="submit" name="btnsubmit" value="确定" class="submit" />
</p>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op == 'addreward') { ?>

<h1>追加投票悬赏</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="<?=$pid?>">
<form id="add_addreward_<?=$pid?>" name="add_addreward_<?=$pid?>" method="post" action="cp.php?ac=poll&op=addreward&pid=<?=$pid?>">
<div id="__add_addreward_<?=$pid?>">
<table>
<tr>
<td>

<label for="addcredit">追加悬赏总额：</label>
<input type="text" class="t_input" id="addcredit" name="addcredit" value="" size="10"/> 范围：0~<?=$space['credit']?>
</td>
</tr>
<?php if($maxreward) { ?>
<tr>
<td>
<label for="addpercredit">追加每人悬赏：</label>
<input type="text" class="t_input" id="addpercredit" name="addpercredit" value="" size="10"/> 范围：0~<?=$maxreward?>
</td>
</tr>
<?php } ?>
<tr>
<td>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="addrewardsubmit" value="true" />
<input type="submit" name="addopt_btn" id="addopt_btn" value="提交" class="submit" />
</td>
</tr>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</div>
</form>
</div>

<?php } elseif($op=='modify') { ?>


<h1>修改投票结束时间</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="expiration_<?=$pid?>">
<form id="modify_expiration_<?=$pid?>" name="modify_expiration_<?=$pid?>" method="post" action="cp.php?ac=poll&op=modify&pid=<?=$pid?>">
<table>
<tr>
<td>
<label for="expiration">请输入新的结束时间：</label><br />
<input type="text" class="t_input" id="expiration" name="expiration" readonly value="<?php echo sgmdate('Y-m-d', $poll[expiration]?$poll[expiration]:$_SGLOBAL[timestamp]+2592000); ?>" size="30" onclick="showcalendar(event, this, 0, '<?php echo sgmdate('Y-m-d',$_SGLOBAL[timestamp]); ?>')"/>
</td>
</tr>
<tr>
<td>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="modifysubmit" value="true" />
<input type="submit" name="modifysubmit_btn" id="modifysubmit_btn" value="提交" class="submit" />
</td>
</tr>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op=='summary') { ?>


<h1>投票总结</h1>
<a href="javascript:hideMenu();" class="float_del" title="关闭">关闭</a>
<div class="popupmenu_inner" id="summary_<?=$pid?>">
<form id="edit_summary_<?=$pid?>" name="edit_summary_<?=$pid?>" method="post" action="cp.php?ac=poll&op=summary&pid=<?=$pid?>">
<table>
<tr>
<td>

<label for="message">请输入对此次投票的总结：</label>
<a href="###" id="editface_<?=$pid?>" onclick="showFace(this.id, 'summary');return false;"><img src="image/facelist.gif" align="absmiddle" /></a>
<img src="image/zoomin.gif" onmouseover="this.style.cursor='pointer'" onclick="zoomTextarea('summary', 1)">

<img src="image/zoomout.gif" onmouseover="this.style.cursor='pointer'" onclick="zoomTextarea('summary', 0)">

<br />
<textarea id="summary" name="summary" cols="70" onkeydown="ctrlEnter(event, 'summarysubmit_btn');" rows="8"><?=$poll['summary']?></textarea></td>
</tr>
<tr>
<td>
<input type="hidden" name="refer" value="<?=$_SGLOBAL['refer']?>" />
<input type="hidden" name="summarysubmit" value="true" />
<input type="submit" name="summarysubmit_btn" id="summarysubmit_btn" value="提交" class="submit" />
</td>
</tr>
</table>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
</div>

<?php } elseif($op == 'get') { ?>
<ul id="vote_list" class="voter_list">
<?php if($voteresult) { ?>
<?php if(is_array($voteresult)) { foreach($voteresult as $value) { ?>
<li>
<?php if($value['uid']==$_SGLOBAL['supe_uid']) { ?>
<img class="meicon" alt="我自己的" src="image/arrow.gif"/>
<?php } ?>
<?php if(empty($value['username'])) { ?>
匿名
<?php } else { ?>
<a href="space.php?uid=<?=$value['uid']?>"><?=$_SN[$value['uid']]?></a>
<?php } ?>
<?php echo sgmdate('Y-m-d H:i:s',$value[dateline],1); ?> 投票给 <?=$value['option']?>
</li>
<?php } } ?>
<?php } else { ?>
<li>暂时没有相关<?php if($_GET['filtrate']=='we') { ?>好友<?php } ?>投票记录</li>
<?php } ?>
</ul>
<?php if($multi) { ?><div class="page"><?=$multi?></div><br/><?php } ?>

<?php } elseif($op == 'invite') { ?>

<form id="inviteform" name="inviteform" method="post" action="cp.php?ac=poll&op=invite&pid=<?=$poll['pid']?>&uid=<?=$_GET['uid']?>&grade=<?=$_GET['grade']?>&group=<?=$_GET['group']?>&page=<?=$_GET['page']?>&start=<?=$_GET['start']?>">

<h2 class="title"><img src="image/app/poll.gif" />投票</h2>
<div class="tabs_header">
<ul class="tabs">
<li><a href="cp.php?ac=poll"><span>发起新投票</span></a></li>
<li class="active"><a href="cp.php?ac=poll&op=invite&pid=<?=$poll['pid']?>"><span>邀请好友</span></a></li>
<li><a href="space.php?uid=<?=$poll['uid']?>&do=poll&pid=<?=$poll['pid']?>"><span>返回投票</span></a></li>
</ul>
</div>
<div id="content" style="width: 640px;">
<div class="h_status">
您可以邀请下列好友来参与<a href="space.php?uid=<?=$poll['uid']?>&do=poll&pid=<?=$poll['pid']?>">《<?=$poll['subject']?>》</a>投票
</div>

<div class="h_status">
<?php if($list) { ?>
<ul class="avatar_list">
<?php if(is_array($list)) { foreach($list as $value) { ?>
<li><div class="avatar48"><a href="space.php?uid=<?=$value['fuid']?>" title="<?=$_SN[$value['fuid']]?>"><?php echo avatar($value[fuid],small); ?></a></div>
<p>
<a href="space.php?uid=<?=$value['fuid']?>" title="<?=$_SN[$value['fuid']]?>"><?=$_SN[$value['fuid']]?></a>
</p>
<p><?php if(empty($invitearr[$value['fuid']])) { ?><input type="checkbox" name="ids[]" value="<?=$value['fuid']?>">选定<?php } else { ?>已邀请<?php } ?></p>
</li>
<?php } } ?>
</ul>
<div class="page"><?=$multi?></div>
<?php } else { ?>
<div class="c_form">还没有好友。</div>
<?php } ?>
</div>
<p>
<input type="checkbox" id="chkall" name="chkall" onclick="checkAll(this.form, 'ids')">全选 &nbsp;
<input type="submit" name="invitesubmit" value="邀请" class="submit" />
</p>
</div>

<div id="sidebar" style="width: 150px;">
<div class="cat">
<h3>好友分类</h3>
<ul class="post_list line_list">
<li<?php if($_GET['group']==-1) { ?> class="current"<?php } ?>><a href="cp.php?ac=poll&pid=<?=$poll['pid']?>&op=invite&group=-1">全部好友</a></li>
<?php if(is_array($groups)) { foreach($groups as $key => $value) { ?>
<li<?php if($_GET['group']==$key) { ?> class="current"<?php } ?>><a href="cp.php?ac=poll&pid=<?=$poll['pid']?>&op=invite&group=<?=$key?>"><?=$value?></a></li>
<?php } } ?>
</ul>
</div>
</div>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</form>
<?php } else { ?>


<?php if($topic) { ?>
<h2 class="title">
<img src="image/app/topic.gif" />热闹 - <a href="space.php?do=topic&topicid=<?=$topicid?>"><?=$topic['subject']?></a>
</h2>
<div class="tabs_header">
<ul class="tabs">
<li class="active"><a href="javascript:;"><span>凑个热闹</span></a></li>
<li><a href="space.php?do=topic&topicid=<?=$topicid?>"><span>查看热闹</span></a></li>
</ul>
<?php if(checkperm('managetopic') || $topic['uid']==$_SGLOBAL['supe_uid']) { ?>
<div class="r_option">
<a href="cp.php?ac=topic&op=edit&topicid=<?=$topic['topicid']?>">编辑</a> | 
<a href="cp.php?ac=topic&op=delete&topicid=<?=$topic['topicid']?>" id="a_delete_<?=$topic['topicid']?>" onclick="ajaxmenu(event,this.id);">删除</a>
</p>
</div>
<?php } ?>
</div>


<div class="affiche">
<table width="100%">
<tr>
<?php if($topic['pic']) { ?>
<td width="160" id="event_icon" valign="top">
<img src="<?=$topic['pic']?>" width="150">
</td>
<?php } ?>
<td valign="top">
<h2>
<a href="space.php?do=topic&topicid=<?=$topic['topicid']?>"><?=$topic['subject']?></a>
</h2>

<div style="padding:5px 0;"><?=$topic['message']?></div>
<ul>
<li class="gray">发起作者: <a href="space.php?uid=<?=$topic['uid']?>"><?=$_SN[$topic['uid']]?></a></li>
<li class="gray">发起时间: <?=$topic['dateline']?></li>
<?php if($topic['endtime']) { ?><li class="gray">参与截止: <?=$topic['endtime']?></li><?php } ?>
<?php if($topic['joinnum']) { ?>
<li class="gray">参与人次: <?=$topic['joinnum']?></li>
<?php } ?>
<li class="gray">最后参与: <?=$topic['lastpost']?></li>
</ul>

<?php if($topic['allowjoin']) { ?>
<a href="<?=$topic['joinurl']?>" class="feed_po" id="hot_add" onmouseover="showMenu(this.id)">凑个热闹</a>
<ul id="hot_add_menu" class="dropmenu_drop" style="display:none;">
<?php if(in_array('blog', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=blog&topicid=<?=$topicid?>">发表日志</a></li>
<?php } ?>
<?php if(in_array('pic', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=upload&topicid=<?=$topicid?>">上传图片</a></li>
<?php } ?>
<?php if(in_array('thread', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=thread&topicid=<?=$topicid?>">发起话题</a></li>
<?php } ?>
<?php if(in_array('poll', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=poll&topicid=<?=$topicid?>">发起投票</a></li>
<?php } ?>
<?php if(in_array('event', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=event&topicid=<?=$topicid?>">发起活动</a></li>
<?php } ?>
<?php if(in_array('share', $topic['jointype'])) { ?>
<li><a href="cp.php?ac=share&topicid=<?=$topicid?>">添加分享</a></li>
<?php } ?>
</ul>
<?php } else { ?>
<p class="r_option">该热闹已经截止</p>
<?php } ?>
</td>
</tr></table>
</div>

<?php } else { ?>
<h2 class="title"><img src="image/app/poll.gif" />投票</h2>
<div class="tabs_header">
<ul class="tabs">
<li class="active"><a href="cp.php?ac=poll"><span>发起新投票</span></a></li>
<li><a href="space.php?do=poll&view=me"><span>返回我的投票</span></a></li>
</ul>
</div>
<?php } ?>

<div class="c_form">

<form id="addnewpoll" name="addnewpoll" method="post" action="cp.php?ac=poll">
<table cellspacing="4" cellpadding="4" width="100%" class="infotable">
<tr>
<th width="80">投票主题</th>
<td>
<input type="text" class="t_input" style="width:450px;" id="subject" name="subject" value=""> <br/>
<a id="addtip" href="javascript:;" onclick="initIntro();" onfocus="this.blur();">添加投票详细说明</a>
</td>
</tr>
<tr id="intropoll" style="display:none">
<th>详细说明</th>
<td><textarea id="message" style="padding: 3px 2px;width:450px;height:50px;" name="message"></textarea> </td>
</tr>
<tr>
<td colspan="2" height="1px"><div style="width: 550px; height:1px; border-bottom:1px solid #DDDDDD;"></div></td>
</tr>
<?php $option=array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20); ?>
<?php if(is_array($option)) { foreach($option as $key => $val) { ?>
<?php if($val==11) { ?>
<tbody id="moreoption" style="display: none;">
<?php } ?>
<tr>
<th>候选项<?=$val?></th>
<td>
<input type="text" class="t_input"  style="width:450px;" name="option[]" value="" maxlength="120">
<?php if($val==10) { ?>
<div><a id="moretip" href="javascript:;" onclick="showMoreOption();" onfocus="this.blur();">增加更多选项</a></div>
<?php } ?>
</td>
</tr>
<?php } } ?>
</tbody>
<tr>
<th>可投选项</th>
<td>
<select name="maxchoice">
<?php if(is_array($option)) { foreach($option as $key => $val) { ?>
<option value="<?=$val?>">
<?php if($val==1) { ?>
单选
<?php } else { ?>
可多选，最多<?=$val?>项
<?php } ?>
</option>
<?php } } ?>
</select>
</td>
</tr>
<tr>
<th>截止时间</th>
<td>
<script type="text/javascript" src="source/script_calendar.js" charset="<?=$_SC['charset']?>"></script>
<input type="text" class="t_input" size="16" id="expiration" readonly name="expiration" value="" onclick="showcalendar(event, this, 0, '<?php echo sgmdate('Y-m-d',$_SGLOBAL[timestamp]); ?>')" />
</td>
</tr>
<tr>
<th>投票限制</th>
<td>
<input type="radio" name="sex" value="0" checked />不限制 
<input type="radio" name="sex" value="1" />男
<input type="radio" name="sex" value="2" />女 
</td>
</tr>
<tr>
<th>评论限制</th>
<td>
<input type="radio" name="noreply" value="0" checked />不限制 
<input type="radio" name="noreply" value="1" />仅限好友
</td>
</tr>
<tr>
<th>悬赏投票</th>
<td>
<input type="radio" name="reward" value="0" checked onclick="initReward(this.value);" />否
<input type="radio" name="reward" value="1" onclick="initReward(this.value);" />是
</td>
</tr>
<tbody id="rewardlist" style="display: none;">
<tr>
<th>悬赏总额</th>
<td>
<input type="text" class="t_input" size="16" id="credit" name="credit" value="" maxlength="60"> 范围：1~<?=$space['credit']?>
</td>
</tr>
<tr>
<th>每人悬赏</th>
<td>
<input type="text" class="t_input" size="16" id="percredit" name="percredit" value="" maxlength="60"> 范围：1~<?=$_SCONFIG['maxreward']?>
</td>
</tr>
</tbody>
<?php if(checkperm('seccode')) { ?>
<?php if($_SCONFIG['questionmode']) { ?>
<tr>
<th style="vertical-align: top;" width="90">请回答验证问题</th>
<td>
<p><?php question(); ?></p>
<input type="text" id="seccode" name="seccode" value="" size="15" class="t_input" />
</td>
</tr>
<?php } else { ?>
<tr>
<th style="vertical-align: top;" width="90">请填写验证码</th>
<td>
<script>seccode();</script>
<p>请输入上面的4位字母或数字，看不清可<a href="javascript:updateseccode()">更换一张</a></p>
<input type="text" id="seccode" name="seccode" value="" size="15" class="t_input" />
</td>
</tr>
<?php } ?>
<?php } ?>

<tr>
<th>动态选项</th>
<td>
<input type="checkbox" name="makefeed" id="makefeed" value="1"<?php if(ckprivacy('poll', 1)) { ?> checked<?php } ?>> 产生动态 (<a href="cp.php?ac=privacy#feed" target="_blank">更改默认设置</a>)
</td>
</tr>

<tr>
<th></th>
<td>
<input type="hidden" name="pollsubmit" id="pollsubmit" value="true" />
<input type="hidden" name="topicid" value="<?=$_GET['topicid']?>" />
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
<input type="submit" name="addpollsubmit" id="addpollsubmit" value="发起投票" class="submit" onclick="validate(this);return false;" />
<div id="__addnewpoll"></div>
</td>
</tr>
</table>
</form>
<script type="text/javascript" charset="<?=$_SC['charset']?>">
function initIntro() {
var introObj = $('intropoll');
var tipObj = $('addtip');
if(introObj.style.display == 'none') {
introObj.style.display = '';

tipObj.innerHTML = "隐藏投票详细说明";
} else {
if (($('message').value.length == 0) || (confirm("详细说明将被清空，你确定要隐藏吗？"))) {
introObj.style.display = 'none';
$('message').value = '';
tipObj.innerHTML = "添加投票详细说明";
}
}
}
function initReward(status) {
var rewardObj = $('rewardlist');
if(status == 1) {
rewardObj.style.display = '';
} else {
rewardObj.style.display = 'none';
$("credit").value = '';
$("percredit").value = '';
}
}
function showMoreOption() {
$("moreoption").style.display = '';
$("moretip").style.display = 'none';
}
function validate(obj) {
    var subject = $('subject');
    if (subject) {
    	var slen = strlen(subject.value);
        if (slen < 1 || slen > 80) {
            alert("标题长度(1~80字符)不符合要求");
            subject.focus();
            return false;
        }
    }
    
    var makefeed = $('makefeed');
    if(makefeed) {
    	if(makefeed.checked == false) {
    		if(!confirm("友情提醒：您确定此次发布不产生动态吗？\n有了动态，好友才能及时看到你的更新。")) {
    			return false;
    		}
    	}
    }
    
var optionCount = 0;
var optionObj = document.getElementsByName("option[]");
for(var i=0;i<optionObj.length;i++) {
if(optionObj[i].value.Trim()!="") {
optionCount++;
}
}
if(optionCount<2) {
alert('请至少添加两个候选项！');
return false;
}
var maxCredit = <?=$space['credit']?>;
var maxPercredit = <?=$_SCONFIG['maxreward']?>;
//验证悬赏投票设置
var credit = parseInt($('credit').value.Trim());
var percredit = parseInt($('percredit').value.Trim());
if(credit || percredit) {
if(!credit) {
alert("请正确填写悬赏总额");
return false;
} else if(!percredit) {
alert("请正确填写每人悬赏积分");
return false;
} else if(credit > maxCredit) {
alert("悬赏总额应在:1~"+maxCredit+"之间取值");
return false;
} else if(maxPercredit && percredit > maxPercredit) {
alert("每人悬赏应在:1~"+maxPercredit+"之间取值");
return false;
} else if(credit < percredit) {
alert("每人悬赏不能高于悬赏总额");
return false;
}
}
var nowDate = parsedate("<?php echo sgmdate('Y-m-d',$_SGLOBAL[timestamp]); ?>");


if($('expiration').value.Trim() != "") {
var expiration = parsedate($('expiration').value.Trim());
if(expiration < nowDate) {
alert("过期时间不能小于当前时间");
return false;
}
}
    if($('seccode')) {
var code = $('seccode').value;
var x = new Ajax();
x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
s = trim(s);
if(s.indexOf('succeed') == -1) {
alert(s);
$('seccode').focus();
           		return false;
}
});
    }
    ajaxpost('addnewpoll', 'poll_post_result');
}
String.prototype.Trim = function() { 
return this.replace(/(^\s*)|(\s*$)/g, ""); 
}
</script>
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
<?php } ?><?php ob_out();?>