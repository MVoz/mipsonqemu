<?php if(!defined('IN_UCHOME')) exit('Access Denied');?><?php subtplcheck('template/default/space_bookmark|template/default/bm_header|template/default/footer', '1266509684', 'template/default/space_bookmark');?><?php $_TPL['nosidebar']=1; ?>
<?php if(empty($_SGLOBAL['inajax'])) { ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=<?=$_SC['charset']?>" />
<meta http-equiv="x-ua-compatible" content="ie=7" />
<title><?php if($_TPL['titles']) { ?><?php if(is_array($_TPL['titles'])) { foreach($_TPL['titles'] as $value) { ?><?php if($value) { ?><?=$value?> - <?php } ?><?php } } ?><?php } ?><?php if($_SN[$space['uid']]) { ?><?=$_SN[$space['uid']]?> - <?php } ?><?=$_SCONFIG['sitename']?> - Powered by UCenter Home</title>

<script language="javascript" type="text/javascript" src="source/jquery-1.4.1.min.js"></script>
<script language="javascript" type="text/javascript" src="source/script_cookie.js"></script>
<script language="javascript" type="text/javascript" src="source/script_common.js"></script>
<script language="javascript" type="text/javascript" src="source/script_menu.js"></script>

<script language="javascript" type="text/javascript" src="source/script_ajax.js"></script>
<script language="javascript" type="text/javascript" src="source/script_face.js"></script>
<script language="javascript" type="text/javascript" src="source/script_manage.js"></script>
<script language="javascript" type="text/javascript" src="source/menu.js"></script>

<script type="text/javascript">
//jQuery.noConflict();
jQuery(document).ready(function(){
       		initMenuEx();
        });
</script>
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

<div id="append_parent">

</div>

<div id="ajaxwaitid"></div>
<div id="bm_header">
<form id="ssform" name="ssform" method="get" action="/subject_search">     
    <a href="index.php" title="豆瓣"><img src="template/<?=$_SCONFIG['template']?>/image/bm_logo.jpg" alt="<?=$_SCONFIG['sitename']?>" class="logo"/></a>
    <div id="nav">
            <a class="now" href="/"><span>首页</span></a>
   <?php if($_SGLOBAL['supe_uid']) { ?>
    				<a href="/"><span>我的弹指</span></a>
   <?php } ?>
            <a  href="/group/"><span>小组</span></a>
            <a  href="/book/"><span>读书</span></a>
            <a  href="/movie/"><span>电影</span></a>
            <a  href="/music/"><span>音乐</span></a>
            <a  href="/event/"><span>同城</span></a>
    </div>    
<div id="searbar">
<span>加为收藏</span>
    <span>设为首页</span>

</div>
    <div id="status">
            <span class="pl">你好，请<a href="/login" rel="nofollow">登录</a>或<a href="/register">注册</a></span>
    </div>
</form>
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

<?php if(!empty($_SGLOBAL['inajax'])) { ?>
<h2 class="ntitle">
<span class="r_option" style="padding-right:150px;">
<ul>
<?php if(isset($_GET['groupid'])) { ?>
        		<li><a href="cp.php?uid=<?=$space['uid']?>&ac=bmdir&bmdirid=<?=$_GET['groupid']?>&op=add" id="bmdir_add_<?=$_GET['groupid']?>" onclick="ajaxmenu(event, this.id,1)">增加</a></li>
            <li><a href="cp.php?uid=<?=$space['uid']?>&ac=bmdir&bmdirid=<?=$_GET['groupid']?>&op=edit" id="bmdir_edit_<?=$_GET['groupid']?>" onclick="ajaxmenu(event, this.id,1)">修改</a></li>
           	<li><a href="cp.php?uid=<?=$space['uid']?>&ac=bmdir&bmdirid=<?=$_GET['groupid']?>&op=delete" id="bmdir_delete_<?=$_GET['groupid']?>" onclick="ajaxmenu(event, this.id)">删除</a></li>
          <?php } ?>
        </ul>	
</span> <?=$groupname?> &raquo;</h2>
<ul class="bloglist">
<?php if(is_array($bookmarklist)) { foreach($bookmarklist as $key => $value) { ?>
<li <?php if($key%2==1) { ?>class="list_r"<?php } ?>>
<h3><a href="<?=$value['url']?>" target="_blank"><?=$value['subject']?></a></h3>
<div class="d_avatar avatar125"><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>" target="_blank"><img src="./template/default/image/1_1264944905dc86.jpg"></a></div>
<p class="message"><?=$value['description']?> ...</p>
<p class="c_date"></p>
          <p class=label><a href="#">足球</a><a href="#">英超</a><a href="#">欧冠</a></p>
<p class="nhot"><a href="space.php?uid=<?=$value['uid']?>&do=blog&id=<?=$value['linkid']?>"><?=$value['hot']?> 人推荐</a></p>
<p class="c_date"></p>
<p class=ndate><span>2010年2月1日</span></p>
  <span class=bvisit><a href="http://192.168.115.2/uc/home/space.php?uid=1&amp;do=blog&amp;id=1">点击访问</a></span>
  <span class=editbtn><a href="http://192.168.115.2/uc/home/space.php?uid=1">编辑</a></span>
<span class=deletebtn><a href="cp.php?ac=bm&uid=<?=$space['uid']?>&bmid=<?=$value['linkid']?>&op=delete">删除</a></span>
</li>
<?php } } ?>

</ul>
<?php } else { ?>
<div id="network">

<script>
function setintro(type) {
var intro = '';
var bPosition = '';
if(type == 'doing') {
intro = '用一句话记录自己生活中的点点滴滴';
bPosition = '0';
} else if(type == 'mtag') {
intro = '创建自己的小圈子，与大家交流感兴趣的话题';
bPosition = '175px';
} else if(type == 'pic') {
intro = '上传照片，分享生活中的精彩瞬间';
bPosition = '55px';
} else if(type == 'app') {
intro = '与好友一起玩转游戏和游戏，增加好友感情';
bPosition = '118px';
} else {
intro = '马上注册，与好友分享日志、照片，一起玩转游戏';
bPosition = '0';
}
$('guest_intro').innerHTML = intro + '......';
$('guest_intro').style.backgroundPosition = bPosition + ' 100%'
}
function scrollPic(e, LN, Width, Price, Speed) {
id = e.id;
if(LN == 'Last'){ scrollNum = Width; } else if(LN == 'Next'){ scrollNum = 0 - Width; }
scrollStart = parseInt(e.style.marginLeft, 10);
scrollEnd = parseInt(e.style.marginLeft, 10) + scrollNum;

MaxIndex = (e.getElementsByTagName('li').length / Price).toFixed(0);
sPicMaxScroll = 0 - Width * MaxIndex;

if(scrollStart == 0 && scrollEnd == Width){
scrollEnd = -1806;
e.style.marginLeft = parseInt(e.style.marginLeft, 10) - Speed + 'px';
} else if(scrollStart == sPicMaxScroll + Width && scrollEnd == sPicMaxScroll){
scrollEnd = 0;
e.style.marginLeft = parseInt(e.style.marginLeft, 10) + Speed + 'px';
}
scrollShowPic = setInterval(scrollShow, 1);

function scrollShow() {
if(scrollStart > scrollEnd) {
if(parseInt(e.style.marginLeft, 10) > scrollEnd) {
$(id + '_last').onclick = function(){ return false; };
$(id + '_next').onclick = function(){ return false; };
e.style.marginLeft = parseInt(e.style.marginLeft, 10) - Speed + 'px';
} else {
clearInterval(scrollShowPic);
$(id + '_last').onclick = function(){ scrollPic(e, 'Last', Width, Price, Speed);return false; };
$(id + '_next').onclick = function(){ scrollPic(e, 'Next', Width, Price, Speed);return false; };
}
} else {
if(parseInt(e.style.marginLeft, 10) < scrollEnd) {
$(id + '_last').onclick = function(){ return false; };
$(id + '_next').onclick = function(){ return false; };
e.style.marginLeft = parseInt(e.style.marginLeft, 10) + Speed + 'px';
} else {
clearInterval(scrollShowPic);
$(id + '_last').onclick = function(){ scrollPic(e, 'Last', Width, Price, Speed);return false; };
$(id + '_next').onclick = function(){ scrollPic(e, 'Next', Width, Price, Speed);return false; };
}					
}
}
}
function scrollShowNav(e, Width, Price, Speed) {
id = e.id;
$(id + '_last').onclick = function(){ scrollPic(e, 'Last', Width, Price, Speed);return false; };
$(id + '_next').onclick = function(){ scrollPic(e, 'Next', Width, Price, Speed);return false; };

}
function getUserTip(obj) {
var tipBox = $('usertip_box');
tipBox.childNodes[0].innerHTML = '<strong>' + obj.rel + ':<\/strong> ' + obj.rev + '...';

var showLeft;
if(obj.parentNode.offsetLeft > 730) {
showLeft = $('showuser').offsetLeft + obj.parentNode.offsetLeft - 148;
tipBox.childNodes[0].style.right = 0;
} else {
tipBox.childNodes[0].style.right = 'auto';
showLeft = $('showuser').offsetLeft + obj.parentNode.offsetLeft;
}
tipBox.style.left = showLeft + 'px';

var showTop; 
if(obj.className == 'uonline') {
showTop = $('showuser').offsetTop + obj.parentNode.offsetTop - tipBox.childNodes[0].clientHeight;
} else {
showTop = $('showuser').offsetTop + obj.parentNode.offsetTop + 48;
}
tipBox.style.top = showTop + 'px';

tipBox.style.visibility = 'visible';
}
</script>

<div id="guestbar" class="nbox">
<div class="nbox_c">
<p id="guest_intro">马上注册，与好友分享日志、照片，一起玩转游戏......</p>
<a href="do.php?ac=<?=$_SCONFIG['register_action']?>" id="regbutton" onmouseover="setintro('register');">马上注册</a>
<p id="guest_app">
<a href="javascript:;" class="appdoing" onmouseover="setintro('doing');">记录</a>
<a href="javascript:;" class="appphotos" onmouseover="setintro('pic');">照片</a>
<a href="javascript:;" class="appgames" onmouseover="setintro('app');">游戏</a>
<a href="javascript:;" class="appgroups" onmouseover="setintro('mtag');">群组</a> 
</p>
</div>	
<?php if(empty($_SGLOBAL['supe_uid'])) { ?>
<div class="nbox_s side_rbox" id="nlogin_box">
<h3 class="ntitle">登录</h3>
<div class="side_rbox_c">
<form name="loginform" action="do.php?ac=<?=$_SCONFIG['login_action']?>&<?=$url_plus?>&ref" method="post">
<p><label for="username">用户名</label> <input type="text" name="username" id="username" class="t_input" value="<?=$membername?>" /></p>
<p><label for="password">密　码</label> <input type="password" name="password" id="password" class="t_input" value="<?=$password?>" /></p>
<p class="checkrow"><input type="checkbox" id="cookietime" name="cookietime" value="315360000" <?=$cookiecheck?> style="margin-bottom: -2px;" /><label for="cookietime">下次自动登录</label></p>
<p class="submitrow">
<input type="hidden" name="refer" value="space.php?do=home" />
<input type="submit" id="loginsubmit" name="loginsubmit" value="登录" class="submit" />
<a href="do.php?ac=lostpasswd">忘记密码?</a>
<input type="hidden" name="formhash" value="<?php echo formhash(); ?>" />
</p>
</form>
</div>
</div>
</div>
<?php } else { ?>
<div class="nbox_s side_rbox" id="nlogin_box">
<h3 class="ntitle">登录</h3>
<div class="side_rbox_c">
<form name="loginform" action="do.php?ac=<?=$_SCONFIG['login_action']?>&<?=$url_plus?>&ref" method="post">
<div class="logined">
<h3>您好！<a href="space.php?do=bookmark" target=_blank><span><?=$_SGLOBAL['supe_username']?></span></a>，欢迎您回来！</h3>
           <div class="d_avatar avatar48">
           	<a title=admin href="http://192.168.115.2/uc/home/space.php?uid=1" target=_blank>
            <img onerror="this.onerror=null;this.src='websample_files/1_1264944904t7cl.jpg'" src="./template/default/image/1_1264944905dc86.jpg">
            </a>
           </div>
           <div class=p_menu>
               <ul class="login_menu">
               		<li><a href="space.php?do=bookmark">我的收藏</a></li>
                  <li class=login_menu_r><a href="cp.php?ac=common&op=logout&uhash=<?=$_SGLOBAL['uhash']?>">退出登录</a></li>
                  <li><a href="#">最近访问</a></li>
                  <li class=login_menu_r><a href="#">最近添加</a></li>
                  <li><a href="#">经常访问</a></li>
                  <li class=login_menu_r><a href="#">最新推荐</a></li>                 
               </ul>
           </div>
           <div class="login_adv">
                                		<ul>
                                				<li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all" >人人网</a></li>
                                			  <li>|<li>
                                			  <li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all">冬瓜网</a></li>
                                			  <li>|</li>
                                			  <li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all">冬瓜网</a></li>
                                	  </ul>
                                	  <ul>
                                	  	<li><a href="http://css9.net/firefox-adds-on-strengthen-firebug/" class="adv_line">武装Firebug的多款Firefox插件</a><li>
                                	  </ul>
           </div>
  </div>
</form>
</div>
</div>
</div>
<?php } ?>

<!--search bar start-->
  <div class="s_clear searchbar">
                    <div class="floatleft searchForm">
                        <form action=cp.php method=get>
   <ul>
   		<li>        
           	 <input class=t_input style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px"
                            size=50 name=searchkey>
 <!--<input type="text" name="search_text" value="Search text" onkeydown="cautareVexio('');" onmousedown="cautareVexio('');" onchange="cautareVexio('');" onfocus="if(document.search.search_text.value=='Search text')  document.search.search_text.value='';" onblur="if(document.search.search_text.value=='')document.search.search_text.value='Search text';" class="cautareF" />-->
   <!--          <a href="javascript:document.search.submit();" id="cautareBtn">搜索</a>-->
             <input class=submit type=submit value=搜索 name=searchsubmit>
       </li>    
            	<li>
            <input type="checkbox" size="2" maxlength="2" value="ON" >
          </li>
                <li>	
<a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all" class="logogoogle">
                                   &nbsp
                                </a>	
</li>
          <li >		
 <select name="baidu_judet" >
 					 <option value="">新闻</option>
                     <option value="">网页</option>
                     <option value="Alba" >图片</option>
 					<option value="Alba" >mp3</option>
</select>
  </li>
  <li>		
<input type="checkbox" size="2" maxlength="2" value="ON" >		
</li>
          <li>	
<a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all" class="logobaidu">
                                   &nbsp
                                </a>	
</li>
          <li>
<select name="google_judet" style="z-index:-10;">
 					 <option value="">新闻</option>
                     <option value="">网页</option>
                     <option value="Alba" >图片</option>
           <option value="Alba" >mp3</option>
</select>
</li>
 </ul>
                        </form>
                    </div>
                    <div class="floatright search_r">
                        <form action=space.php method=get>
                            <input class=t_input style="padding-right: 5px; padding-left: 3px; padding-bottom: 5px; padding-top: 5px"
                            size=15 name=searchkey>
                            <select name=do>
                                <option value=blog selected>日志</option>
                                <option value=album>相册</option>
                                <option value=thread>话题</option>
                                <option value=poll>投票</option>
                                <option value=event>活动</option>
                            </select>
                            <input class=submit type=submit value=搜索 name=searchsubmit>
                            <input type=hidden value=all name=view>
                            <input type=hidden value=dateline name=orderby>
                        </form>
                    </div>
                  </div>
<!--searchBar end-->
<div class="nbox" style="height:650px;">

<div class="nbox_c">
<div id="bmcontent">
<h2 class="ntitle">

<span class="r_option" style="padding-right:150px;">
<ul>
<?php if(isset($_GET['groupid'])) { ?>
        		<li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all">增加</a></li>
            <li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all">修改</a></li>
           	<li><a href="http://192.168.115.2/uc/home/space.php?do=blog&amp;view=all">删除</a></li>
           	<?php } ?>
        </ul>	
</span> 日志 &raquo;</h2>
<ul class="bloglist">
<?php if(is_array($bookmarklist)) { foreach($bookmarklist as $key => $value) { ?>
<li <?php if($key%2==1) { ?>class="list_r"<?php } ?>>
<h3><a href="<?=$value['url']?>" target="_blank"><?=$value['subject']?></a></h3>
<div class="d_avatar avatar125"><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>" target="_blank"><img src="./template/default/image/1_1264944905dc86.jpg"></a></div>
<p class="message"><?=$value['description']?> ...</p>
<p class="c_date"></p>
          <p class=label><a href="#">足球</a><a href="#">英超</a><a href="#">欧冠</a></p>
<p class="nhot"><a href="space.php?uid=<?=$value['uid']?>&do=blog&id=<?=$value['linkid']?>"><?=$value['hot']?> 人推荐</a></p>
<p class="c_date"></p>
<p class=ndate><span>2010年2月1日</span></p>
  <span class=bvisit><a href="http://192.168.115.2/uc/home/space.php?uid=1&amp;do=blog&amp;id=1">点击访问</a></span>
  <span class=editbtn><a href="http://192.168.115.2/uc/home/space.php?uid=1">编辑</a></span>
<span class=deletebtn><a href="cp.php?ac=bm&uid=<?=$space['uid']?>&bmid=<?=$value['linkid']?>&op=delete">删除</a></span>
</li>
<?php } } ?>

</ul>
</div>
</div>

<div class="nbox_s side_rbox side_rbox_w">
<h2 class="ntitle"><span class="r_option"><a href="space.php?do=doing&view=all">更多记录</a></span> 记录 &raquo;</h2>
<div class="side_rbox_c">
                            <div class="menu_item">
                            	<div class="tabs_header">
<ul class="tabs">
<li class="active">
<a href="space.php?do=pm"><span>IE</span></a>																		
</li>
<li><a href="space.php?do=notice"><span>Firefox</span></a></li>
<li><a href="space.php?do=notice"><span>Opera</span></a></li>
</ul>
</div>
                            	
                                <ul id="menu" class="menu_list">
                                	<?php usermenu() ?>
                                </ul>
                                
                            </div>
</div>
<h2 class=ntitle_1>
                        </h2>
                        <div class=side_rbox_c>
<a title=admin href="http://192.168.115.2/uc/home/space.php?uid=1" target=_blank>
                                        <img onerror="this.onerror=null;this.src='./template/default/image/1_1264944905dc86.jpg'"
                                        src="./template/default/image/1_1264944905dc86.jpg">
                                    </a>
                        </div>
</div>
 						
</div>



<div class="nbox" id="photolist">
<h2 class="ntitle">
<a href="space.php?do=album&view=all" class="r_option">更多图片</a>
图片 &raquo;
</h2>
<div id="p_control">
<a href="javascript:;" id="spics_last">上一页</a>
<a href="javascript:;" id="spics_next">下一页</a>
<ul id="p_control_pages">
<li>第一页</li>
<li>第二页</li>
<li>第三页</li>
<li>第四页</li>
</li>
</div>
<div id="spics_wrap">
<ul id="spics" style="margin-left: 0px;">
<?php if(is_array($piclist)) { foreach($piclist as $key => $value) { ?>
     <li class=spic_0>
     <div class="avatar125_1"><a href="http://192.168.115.2/uc/home/space.php?uid=1&amp;do=album&amp;picid=5" target=_blank><img alt=我的相册 src="./template/default/image/1_1264944905dc86.jpg"></a></div>
     <p>人人网</p>
     <p class="c_date"></p>
     <p class=label>
                                    <a href="#" style="float:left;padding-left:2px;">
                                        足球
                                    </a>
                                    <a href="#" style="float:left;padding-left:12px;">
                                        英超
                                    </a>

     </p>
     </li>
<?php } } ?>
</ul>
</div>
</div>
<script type="text/javascript">
scrollShowNav($('spics'), 903, 7, 43);
</script>


<div id="showuser" class="nbox">
<div id="user_recomm">
<h2>站长推荐</h2>
<?php if(is_array($star)) { foreach($star as $value) { ?>
<div class="s_avatar"><a href="space.php?uid=<?=$value['uid']?>" target="_blank"><?php echo avatar($value[uid],middle); ?></a></div>
<div class="s_cnts">
<h3><a href="space.php?uid=<?=$value['uid']?>" title="<?=$_SN[$value['uid']]?>"><?=$_SN[$value['uid']]?></a></h3>
<p>访问: <?=$value['viewnum']?></p>
<p>积分: <?=$value['credit']?></p>
<hr />
<p>好友: <?=$value['friendnum']?></p>
<p>更新: <?php echo sgmdate('H:i',$value[updatetime],1); ?></p>
</div>
<?php } } ?>
</div>
<div id="user_wall" onmouseout="javascript:$('usertip_box').style.visibility = 'hidden';">
<div id="user_pay" class="s_clear">
<h2><a href="space.php?do=top">竞价排名</a></h2>
<ul>
<?php if(is_array($showlist)) { foreach($showlist as $value) { ?>
<li><a href="space.php?uid=<?=$value['uid']?>" target="_blank" rel="<?=$_SN[$value['uid']]?>" rev="<?=$value['note']?>" onmouseover="getUserTip(this)"><?php echo avatar($value[uid],small); ?></a></li>
<?php } } ?>
</ul>
<p><a href="space.php?do=top">我要上榜</a></p>
</div>
<div id="user_online" class="s_clear">
<h2><a href="space.php?do=top&view=online">在线会员</a></h2>
<ul>
<?php if(is_array($onlinelist)) { foreach($onlinelist as $value) { ?>
<li><a href="space.php?uid=<?=$value['uid']?>" target="_blank" rel="<?=$_SN[$value['uid']]?>" rev="<?=$value['note']?>" class="uonline" onmouseover="getUserTip(this)"><?php echo avatar($value[uid],small); ?></a></li>
<?php } } ?>
</ul>
</div>
</div>
</div>
<div id="usertip_box"><div></div></div>

<div class="nbox">
<div class="nbox_c">
<h2 class="ntitle"><span class="r_option"><a href="space.php?do=thread&view=all">更多话题</a></span>话题 &raquo;</h2>
<div class="tlist">


<div class="collection_info">      
        <div class="headpicture_info">
          <div class="headpicture_infoleft">
            <div class="act_headpicture"></div>
            <div class="act_headbtn"><a href="#"><img src="./template/default/image/collection_btn.jpg" /></a></div>
          </div>
          <div class="headpicture_inforight">
          	  <div class="dig_title"><a href="#">
          <h3>head picture head picture head picture</h3>
        </a></div>
            <div class="dig_synopsis"> <a href="#">After paying due consideration to your proposals and investigating your business </a></div>
            <div class="dig_action">
              <div class="support"><a href="#"><img src="./template/default/image/icon_support.jpg" /></a></div>
              <div class="data">(15)</div>
              <div class="bury"><a href="#"><img src="./template/default/image/icon_bury.jpg"/></a></div>
              <div class="data">(5)</div>
              <div class="discuss"><a href="#"><img src="./template/default/image/icon_discuss.jpg"/></a></div>
              <div class="data">(5)</div>
              <div class="clear"></div>
            </div>          
          </div>
                        <div class="headpicture_inforight_1">
            		<div class="d_avatar avatar125">
                                    <a title=admin href="http://192.168.115.2/uc/home/space.php?uid=1" target=_blank>
                                        <img onerror="this.onerror=null;this.src='./template/default/image/1_1264944905dc86.jpg'"
                                        src="./template/default/image/1_1264944905dc86.jpg">
                                    </a>
               </div>
            </div>
        </div>
      </div>
      
      
</div>
</div>
<div id="npoll" class="nbox_s side_rbox side_rbox_w">
<div class="side_rbox_c">
<h2 class="ntitle"><span class="r_option"><a href="space.php?do=poll">更多投票</a></span>投票 &raquo;</h2>
<ul>
<?php if(is_array($polllist)) { foreach($polllist as $key => $value) { ?>
<li class="poll_<?=$key?>"><a href="space.php?uid=<?=$value['uid']?>&do=poll&pid=<?=$value['pid']?>" target="_blank"><?=$value['subject']?></a><?php if($key == 0) { ?><p><a href="">已有 <?=$value['voternum']?> 位会员投票</a></p><?php } ?></li>
<?php } } ?>
</ul>
</div>
</div>
</div>
<div class="fbbottom"></div>
</div>

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
<script>
function getbmfromid(id) {
//var plus = '';
//if(type == 'event') plus = '&type=self';
//ajaxget('space.php?uid=<?=$space['uid']?>&do='+type+'&view=me'+plus+'&ajaxdiv=maincontent', 'maincontent');
ajaxget('space.php?uid=<?=$space['uid']?>&do=bookmark&groupid='+id+'&ajaxdiv=bmcontent', 'bmcontent');
}
</script>
<?php } ?><?php ob_out();?>