/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: script_common.js 13191 2009-08-18 03:14:55Z xupeng $
*/

var userAgent = navigator.userAgent.toLowerCase();
var is_opera = userAgent.indexOf('opera') != -1 && opera.version();
var is_moz = (navigator.product == 'Gecko') && userAgent.substr(userAgent.indexOf('firefox') + 8, 3);
var is_ie = (userAgent.indexOf('msie') != -1 && !is_opera) && userAgent.substr(userAgent.indexOf('msie') + 5, 3);
var is_safari = (userAgent.indexOf('webkit') != -1 || userAgent.indexOf('safari') != -1);
var note_step = 0;
var note_oldtitle = document.title;
var note_timer;

//iframe包含
if (top.location != location) {
	top.location.href = location.href;
}

function $obj(id) {
	return document.getElementById(id);
}
 /*
function addSort(obj) {
	if (obj.value == 'addoption') {
 	var newOptDiv = document.createElement('div')
 	newOptDiv.id = obj.id+'_menu';
 	newOptDiv.innerHTML = '<h1>添加</h1><a href="javascript:;" onclick="addOption(\'newsort\', \''+obj.id+'\')" class="float_del">删除</a><div class="popupmenu_inner" style="text-align: center;">名称：<input type="text" name="newsort" size="10" id="newsort" class="t_input" /><input type="button" name="addSubmit" value="创建" onclick="addOption(\'newsort\', \''+obj.id+'\')" class="button" /></div>';
 	newOptDiv.className = 'popupmenu_centerbox';
 	newOptDiv.style.cssText = 'position: absolute; left: 50%; top: 200px; width: 400px; margin-left: -200px;';
 	document.body.appendChild(newOptDiv);
 	$obj('newsort').focus();
 	}
}
	
function addOption(sid, aid) {
	var obj = $obj(aid);
	var newOption = $obj(sid).value;
	$obj(sid).value = "";
	if (newOption!=null && newOption!='') {
		var newOptionTag=document.createElement('option');
		newOptionTag.text=newOption;
		newOptionTag.value="new:" + newOption;
		try {
			obj.add(newOptionTag, obj.options[0]); // doesn't work in IE
		} catch(ex) {
			obj.add(newOptionTag, obj.selecedIndex); // IE only
		}
		obj.value="new:" + newOption;
	} else {
		obj.value=obj.options[0].value;
	}
	// Remove newOptDiv
	var newOptDiv = document.getElementById(aid+'_menu');
	var parent = newOptDiv.parentNode;
	var removedChild = parent.removeChild(newOptDiv);
}

function checkAll(form, name) {
	for(var i = 0; i < form.elements.length; i++) {
		var e = form.elements[i];
		if(e.name.match(name)) {
			e.checked = form.elements['chkall'].checked;
		}
	}
}
 */
function cnCode(str) {
	return is_ie && document.charset == 'utf-8' ? encodeURIComponent(str) : str;
}

function isUndefined(variable) {
	return typeof variable == 'undefined' ? true : false;
}

function in_array(needle, haystack) {
	if(typeof needle == 'string' || typeof needle == 'number') {
		for(var i in haystack) {
			if(haystack[i] == needle) {
					return true;
			}
		}
	}
	return false;
}

function strlen(str) {
	return (is_ie && str.indexOf('\n') != -1) ? str.replace(/\r?\n/g, '_').length : str.length;
}

function getExt(path) {
	return path.lastIndexOf('.') == -1 ? '' : path.substr(path.lastIndexOf('.') + 1, path.length).toLowerCase();
}

function doane(event) {
	e = event ? event : window.event;
	if(is_ie) {
		e.returnValue = false;
		e.cancelBubble = true;
	} else if(e) {
		e.stopPropagation();
		e.preventDefault();
	}
}

//验证码
function seccode() {
	var img = 'do.php?ac=seccode&rand='+Math.random();
	document.writeln('<img id="img_seccode" src="'+img+'" align="absmiddle">');
}
function updateseccode() {
	var img = 'do.php?ac=seccode&rand='+Math.random();
	if($obj('img_seccode')) {
		$obj('img_seccode').src = img;
	}
}
function updateseccodeex(id) {
	var img = 'do.php?ac=seccode&rand='+Math.random();
	if($obj(id)) {
		$obj(id).src = img;
	}
}

//Ctrl+Enter 发布
function ctrlEnter(event, btnId, onlyEnter) {
	if(isUndefined(onlyEnter)) onlyEnter = 0;
	if((event.ctrlKey || onlyEnter) && event.keyCode == 13) {
		$obj(btnId).click();
		return false;
	}
	return true;
}

//验证是否有选择记录
function ischeck(id, prefix) {
	form = document.getElementById(id);
	for(var i = 0; i < form.elements.length; i++) {
		var e = form.elements[i];
		if(e.name.match(prefix) && e.checked) {
			if(confirm("您确定要执行本操作吗？")) {
				return true;
			} else {
				return false;
			}
		}
	}
	alert('请选择要操作的对象');
	return false;
}
function showPreview(val, id) {
	var showObj = $obj(id);
	if(typeof showObj == 'object') {
		showObj.innerHTML = val.replace(/\n/ig, "<br />");
	}
}

function getEvent() {
	if (document.all) return window.event;
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if((arg0.constructor==Event || arg0.constructor ==MouseEvent) || (typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func=func.caller;
	}
	return null;
}
/*
function insertWebImg(obj) {
	if(checkImage(obj.value)) {
		insertImage(obj.value);
		obj.value = 'http://';
	} else {
		alert('图片地址不正确');
	}
}

function checkFocus(target) {
	var obj = $obj(target);
	if(!obj.hasfocus) {
		obj.focus();
	}
}
function insertImage(text) {
	text = "\n[img]" + text + "[/img]\n";
	insertContent('message', text)
}

function insertContent(target, text) {
	var obj = $obj(target);
	selection = document.selection;
	checkFocus(target);
	if(!isUndefined(obj.selectionStart)) {
		var opn = obj.selectionStart + 0;
		obj.value = obj.value.substr(0, obj.selectionStart) + text + obj.value.substr(obj.selectionEnd);
	} else if(selection && selection.createRange) {
		var sel = selection.createRange();
		sel.text = text;
		sel.moveStart('character', -strlen(text));
	} else {
		obj.value += text;
	}
}

function checkImage(url) {
	var re = /^http\:\/\/.{5,200}\.(jpg|gif|png)$/i
	return url.match(re);
}
*/
function quick_validate(obj) {
    if($obj('seccode')) {
		var code = $obj('seccode').value;
		var x = new Ajax();
		x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
			s = trim(s);
			if(s != 'succeed') {
				alert(s);
				$obj('seccode').focus();
           		return false;
			} else {
				obj.form.submit();
				return true;
			}
		});
    } else {
    	obj.form.submit();
    	return true;
    }
}

function trim(str) { 
	var re = /\s*(\S[^\0]*\S)\s*/; 
	re.exec(str); 
	return RegExp.$1; 
}

//滚动
function startMarquee(h, speed, delay, sid) {
	var t = null;
	var p = false;
	var o = $obj(sid);
	o.innerHTML += o.innerHTML;
	o.onmouseover = function() {p = true}
	o.onmouseout = function() {p = false}
	o.scrollTop = 0;
	function start() {
	    t = setInterval(scrolling, speed);
	    if(!p) {
			o.scrollTop += 2;
		}
	}
	function scrolling() {
	    if(p) return;
		if(o.scrollTop % h != 0) {
	        o.scrollTop += 2;
	        if(o.scrollTop >= o.scrollHeight/2) o.scrollTop = 0;
	    } else {
	        clearInterval(t);
	        setTimeout(start, delay);
	    }
	}
	setTimeout(start, delay);
}

function readfeed(obj, id) {
	if(Cookie.get("read_feed_ids")) {
		var fcookie = Cookie.get("read_feed_ids");
		fcookie = id + ',' + fcookie;
	} else {
		var fcookie = id;
	}
	Cookie.set("read_feed_ids", fcookie, 48);
	obj.className = 'feedread';
}
/*
function showreward() {
	if(Cookie.get('reward_notice_disable')) {
		return false;
	}
	var x = new Ajax();
	x.get('do.php?ac=ajax&op=getreward', function(s){
		if(s) {
			msgwin(s, 2000);
		}
	});
}
*/
function msgwin(s, t) {
	
	var msgWinObj = $obj('msgwin');
	if(!msgWinObj) {
		var msgWinObj = document.createElement("div");
		msgWinObj.id = 'msgwin';
		msgWinObj.style.display = 'none';
		msgWinObj.style.position = 'absolute';
		msgWinObj.style.zIndex = '100000';
		$obj('append_parent').appendChild(msgWinObj);
	}
	msgWinObj.innerHTML = s;
	msgWinObj.style.display = '';
	msgWinObj.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=0)';
	msgWinObj.style.opacity = 0;
	var sTop = document.documentElement && document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop;
	pbegin = sTop + (document.documentElement.clientHeight / 2);
	pend = sTop + (document.documentElement.clientHeight / 5);
	setTimeout(function () {showmsgwin(pbegin, pend, 0, t)}, 10);
	msgWinObj.style.left = ((document.documentElement.clientWidth - msgWinObj.clientWidth) / 2) + 'px';
	msgWinObj.style.top = pbegin + 'px';
}

function showmsgwin(b, e, a, t) {
	step = (b - e) / 10;
	var msgWinObj = $obj('msgwin');
	newp = (parseInt(msgWinObj.style.top) - step);
	if(newp > e) {
		msgWinObj.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + a + ')';
		msgWinObj.style.opacity = a / 100;
		msgWinObj.style.top = newp + 'px';
		setTimeout(function () {showmsgwin(b, e, a += 10, t)}, 10);
	} else {
		msgWinObj.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=100)';
		msgWinObj.style.opacity = 1;
		setTimeout('displayOpacity(\'msgwin\', 100)', t);
	}
}

function displayOpacity(id, n) {
	if(!$obj(id)) {
		return;
	}
	if(n >= 0) {
		n -= 10;
		$obj(id).style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + n + ')';
		$obj(id).style.opacity = n / 100;
		setTimeout('displayOpacity(\'' + id + '\',' + n + ')', 50);
	} else {
		$obj(id).style.display = 'none';
		$obj(id).style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=100)';
		$obj(id).style.opacity = 1;
	}
}

function display(id) {
	var obj = $obj(id);
	obj.style.display = obj.style.display == '' ? 'none' : '';
}

function urlto(url) {
	window.location.href = url;
}

function explode(sep, string) {
	return string.split(sep);
}
/*
function selector(pattern, context) {
	var re = new RegExp('([a-z]*)([\.#:]*)(.*|$)', 'ig');
	var match = re.exec(pattern);
	var conditions = [];	
	if (match[2] == '#')	conditions.push(['id', match[3]]);
	else if(match[2] == '.')	conditions.push(['className', match[3]]);
	else if(match[2] == ':')	conditions.push(['type', match[3]]);	
	var s = match[3].replace(/\[(.*)\]/g,'$1').split('@');
	for(var i=0; i<s.length; i++) {
		var cc = null;
		if (cc = /([\w]+)([=^%!$~]+)(.*)$/.exec(s[i])){
			conditions.push([cc[1], cc[2], cc[3]]);
		}
	}
	var list = (context || document).getElementsByTagName(match[1] || "*");	
	if(conditions) {
		var elements = [];
		var attrMapping = {'for': 'htmlFor', 'class': 'className'};
		for(var i=0; i<list.length; i++) {
			var pass = true;
			for(var j=0; j<conditions.length; j++) {
				var attr = attrMapping[conditions[j][0]] || conditions[j][0];
				var val = list[i][attr] || (list[i].getAttribute ? list[i].getAttribute(attr) : '');
				var pattern = null;
				if(conditions[j][1] == '=') {
					pattern = new RegExp('^'+conditions[j][2]+'$', 'i');
				} else if(conditions[j][1] == '^=') {
					pattern = new RegExp('^' + conditions[j][2], 'i');
				} else if(conditions[j][1] == '$=') {
					pattern = new RegExp(conditions[j][2] + '$', 'i');
				} else if(conditions[j][1] == '%=') {
					pattern = new RegExp(conditions[j][2], 'i');
				} else if(conditions[j][1] == '~=') {
					pattern = new RegExp('(^|[ ])' + conditions[j][2] + '([ ]|$)', 'i');
				}
				if(pattern && !pattern.test(val)) {
					pass = false;
					break;
				}
			}
			if(pass) elements.push(list[i]);
		}
		return elements;
	} else {
		return list;
	}
}
*/
function add_favorite()
{ 
	if (document.all)  
	{
		$obj("homepage").setHomePage('http://www.tanzhi.com');
	}
	else if (window.sidebar)  
	window.sidebar.addPanel('弹指网', 'http://www.tanzhi.com', "");
}

function bookmarkload(){
		$(".id_nodes").each(function(){
			$(this).html("暂时没有对&nbsp;<a class=\"url id_bm_"+this.id+"\" id=\""+this.id+"\"></a>&nbsp;的描述，你可以点击<a class=\"edit id_bm_edit_"+this.id+"\" id=\""+this.id+"\">编辑</a>按钮或者等待服务器更新 ...");
		});
		$(".bklt >li >h3 >a").attr("style","float:left;max-width:200px;overflow:hidden;");

		$(".bklt .edit").each(function(){
			$(this).addClass("thickbox");
//			this.href="cp.php?ac=bookmark&bmid=189&groupid=0&browserid=1&op=edit"; 
			this.href = "cp.php?ac=bookmark&bmid="+this.id+"&groupid="+gpid+"&browserid="+bsid+"&op=edit&inajax=1";			
			//$(this).attr("onclick",
			//	"ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);");
//			this.id="bookmark_edit_"+this.id;
		});	
		$(".bklt .delete").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=bookmark&bmid="+this.id+"&groupid="+gpid+"&browserid="+bsid+"&op=delete&inajax=1&height=85";
			//this.id="bookmark_delete_"+this.id;
			//$(this).attr("onclick","ajaxmenu(event, this.id,1)");
		});	
		$(".bklt .get").each(function(){
			this.href="cp.php?ac=bookmark&op=get&bmid="+this.id;
		});	
		$(".bklt .url").each(function(){
			$(this).attr("onclick","updatestatics('bookmark','updatebookmarkview',"+this.id+")");
		});	
		
		$(".bklt a").attr("target","_blank");
		
		$(".id_bm_tag").each(function(){
			this.href = "javascript:;";
			$(this).attr("onclick","getAjax('bmtagview',"+this.id+");").attr("target","_self");
		});	

		$(".bklt .share").each(function(){
			this.href="javascript:void(0)";
			$(this).attr("onclick","updatebookmarkup("+this.id+")").attr("target","_self");
		});	
		$(".bklt > li:even").addClass("list_r");;
		$(".bklt .delete").html("删除");
		$(".bklt .share").html("分享");
		$(".bklt .edit").html("编辑");
		$(".bklt .get").html("详情");
		tb_init('a.thickbox');
}
function siteload(){
		$(".id_nodes").each(function(){
			$(this).html("暂时没有对&nbsp;<a class=\"url id_st_"+this.id+"\" id=\""+this.id+"\"></a>&nbsp;的描述，你可以点击<a class=\"edit id_st_edit_"+this.id+"\" id=\""+this.id+"\">编辑</a>按钮或者等待服务器更新 ...");
		});
		$(".bklt >li >h3 >a").attr("style","float:left;width:250px;overflow:hidden;");
		$(".id_st_tag").each(function(){
			this.href = "space.php?do=sitetag&tagid=" + this.id;
		});	
		$(".bklt .edit").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=edit&inajax=1";			
			//$(this).attr("onclick","ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);");
			//this.id="bookmark_edit2_"+this.id;
		});	
		$(".bklt .delete").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=delete&inajax=1&height=85";
		//	this.id="bookmark_delete_"+this.id;
		//	$(this).attr("onclick","ajaxmenu(event, this.id,1)");
		});	
		$(".bklt .bm").each(function(){
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=bookmark";
			this.id="bookmark_edit2_"+this.id;
		});	
		$(".bklt .get").each(function(){
			this.href="cp.php?ac=site&op=get&siteid="+this.id;
		});	
		$(".bklt .url").each(function(){
			$(this).attr("onclick","updatestatics('site','updatesiteviewnum',"+this.id+")");
		});			
		$(".bklt a").attr("target","_blank");
		$(".bklt .tags > span").html("什么也没留下...");
		$(".bklt .collect").each(function(){
			this.href="cp.php?ac=site&op=bookmark&siteid="+this.id;			
		});
		$(".bklt > li:even").addClass("list_r");
		$(".bklt .delete").html("删除");
		$(".bklt .edit").html("编辑");
		$(".bklt .get").html("详情");
		$(".bklt .collect").html("收藏");
		tb_init('a.thickbox');
}

function diggload(){
		$(".id_dg_tag").each(function(){
			this.href = "space.php?do=diggtag&tagid=" + this.id;
		});	
		$(".tlist .edit").each(function(){
			$(this).attr("onclick","ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);").attr("href","cp.php?ac=digg&op=edit&diggid="+this.id).attr("id","digg_edit_"+this.id);
		});	
		$(".tlist .delete").each(function(){
			$(this).attr("onclick","ajaxmenu(event,this.id,1)").attr("href","cp.php?ac=digg&op=delete&diggid="+this.id).attr("id","digg_delete_"+this.id);
		});	
		$(".tlist .up").each(function(){
			$(this).attr("href","javascript:void(0)").attr("onclick","updatediggup("+this.id+")").attr("target","_self");
		});	
		$(".tlist .down").each(function(){
			$(this).attr("href","javascript:void(0)").attr("onclick","updatediggdown("+this.id+")").attr("target","_self");
		});	
		$(".tlist .delete").html("删除");
		$(".tlist .edit").html("编辑");
}
function searchsubmit()
{
			 var i=0;				
			 $('#shfm input[type=checkbox]').each(function(){ 					 
					if($(this).attr("checked")==true){ 						
						$("#"+'searchkey_'+i).val($('#searchkey').val());	
						$("#"+'searchform_'+i).submit();
					}
					i++;
			 });
			 return false;
}

function setquickmenu(type)
{
	 var qkmus = {
		  lastvisit: [['最近访问']],
		  oftenvisit: [['经常访问']],
		  lastadd: [['最新添加']],
		  mycharts: [['我的上榜']]
	 };
	 getAjax('bmview',type);
	 $('#qkmut').text(qkmus[type][0][0]);
	 $('#qkmu >li').find('ul').eq(0).css('visibility', 'hidden');
	 if($('#groupdo'))
		 $('#groupdo').html("");
	 if($('#groupname'))
		 $('#groupname').html(qkmus[type][0][0]+' &raquo;');

	
}
function qkmu_open(){$('#qkmu >li').find('ul').eq(0).css('visibility', 'visible');}
function qkmu_close(){$('#qkmu >li').find('ul').eq(0).css('visibility', 'hidden');}
$(function(){
		$(".prse span:first").addClass("currentx");  
			$(".prse ul:not(:first)").hide(); 
			$(".prse span").click(function(){ 
				$(".prse span").removeClass("currentx"); 
				$(this).addClass("currentx"); 
				$(".prse ul").hide(); 
				$("."+$(this).attr("id")).show();
			});
});

$(function(){
			$(".shaa span:first").addClass("currentx");
			currentid= getCookie(getSearchTabCookieName());
			$(".shaa span").click(function(){
				$(".shaa span").removeClass("currentx");  
				$(this).addClass("currentx"); 
				$('#shfm input[type=checkbox]').remove();
				$('#shfm span').remove();

				$("#hidden_form").empty();
				var i=0;
				setSearchTab($(this).attr("id"));
				var len = searchs[$(this).attr("id")].length;
				for (i = 0; i < len; i++) {
				 //set checkbox
					var f = document.createElement("INPUT");
					f.type = "checkbox";
					f.name = searchs[$(this).attr("id")][i][0];
					f.id = "check_"+i;
					$('#shfm').append(f);
					$("#"+f.id).attr("checked",(searchs[$(this).attr("id")][i][6]==1)?true:false);
					
					$('#shfm').append('<span>'+searchs[$(this).attr("id")][i][3]+'</span>');
				  //set hidden form
					 hiddenformArr='<form id="searchform_'+i+'" target="_blank" action="'+searchs[$(this).attr("id")][i][1]+'"  method="get" style="display:none">'+' <p> <input type="text" name="'+searchs[$(this).attr("id")][i][2]+'"  id="searchkey_'+i+'"></p></form>';

					
					$("#hidden_form").append(hiddenformArr);					
					//set hidden input						 
					 if (searchs[$(this).attr("id")][i][7]!= null) {
						var c = searchs[$(this).attr("id")][i][7].split(";");
						for (var d = 0, l = c.length; d < l; d++) {
							var e = c[d].split(":");
							var f = document.createElement("INPUT");
							f.type = "hidden";
							f.name = e[0];
							f.id = e[0];
							f.value = e[1];
							$('#searchform_'+i).append(f);
						}
					}
				 }
				 //set button value				 
				 $("#searchbtn").attr("value",$(this).html()+'搜索');
		});
		if($('.shaa #'+currentid))
			$('.shaa #'+currentid).click(); 
		else
			$(".shaa span:first").click();
});
$(function(){
			$("#hhlt .num_con").css("margin-top","-20px");
			$("#hhlt a").css("display","block").css("width","180px");
			$("#hhlt p span").css("cursor","pointer");
			$("#hhlt span:odd").css("background-color","#7BAD00");
			$("#hhlt span:even").css("background-color","#FF8901");
			$("#hhlt span:first").css("background-color","#FFF").css("border-color","#fff").addClass("currentx"); 
			$("#hhlt dl:not(:first)").hide();
			$("#hhlt span").click(function(){ 
				$("#hhlt span").removeClass("currentx"); 
				$("#hhlt span:odd").css("background-color","#7BAD00");
				$("#hhlt span:even").css("background-color","#FF8901");
				$(this).css("background-color","#FFF").css("border-color","#fff").addClass("currentx"); ; 
				$("#hhlt dl").hide(); 
				$("."+$(this).attr("id")).show();
		});
});
$(function(){
	$('#qkmu > li').bind('mouseover', qkmu_open);
	$('#qkmu > li').bind('mouseout',  qkmu_close);
});
document.onclick = qkmu_close;
