var userAgent = navigator.userAgent.toLowerCase();
var is_opera = userAgent.indexOf('opera') != -1 && opera.version();
var is_moz = (navigator.product == 'Gecko') && userAgent.substr(userAgent.indexOf('firefox') + 8, 3);
var is_ie = (userAgent.indexOf('msie') != -1 && !is_opera) && userAgent.substr(userAgent.indexOf('msie') + 5, 3);
var is_safari = (userAgent.indexOf('webkit') != -1 || userAgent.indexOf('safari') != -1);
var note_step = 0;
var note_oldtitle = document.title;
var note_timer;
var searchs = {
    web_page: [
        ["\u7f51\u9875", "http://www.baidu.com/s", "wd", "\u767e\u5ea6", -1, "http://www.baidu.com/index.php",1,"ie:utf-8"],
        ["\u7f51\u9875", "http://www.google.cn/search", "q", "\u8c37\u6b4c", -29, "http://www.google.cn/webhp?client=aff-360daohang",1, "client:aff-360daohang;hl:zh-CN;ie:utf-8"]
    ],
    music: [
        ["MP3", "http://mp3.baidu.com/m", "word", "\u767e\u5ea6", -1, "http://mp3.baidu.com/",1, "f:ms;ct:134217728;ie:utf-8"],
        ["\u97f3\u4e50", "http://www.google.cn/music/search", "q", "\u8c37\u6b4c", -29, "http://www.google.cn/music/?client=aff-360daohang",1, "client:aff-360daohang;hl:zh-CN;ie:utf-8;oe:utf-8"],
        ["\u641c\u72d7", "http://mp3.sogou.com/music", "query", "\u641c\u72d7", -208, "http://mp3.sogou.com/",0]
    ],
    image: [
        ["\u56fe\u7247", "http://image.baidu.com/i", "word", "\u767e\u5ea6", -1, "http://image.baidu.com/",1, "cl:2;lm:-1;ct:201326592"],
        ["\u56fe\u7247", "http://images.google.cn/images", "q", "\u8c37\u6b4c", -29, "http://images.google.cn/imghp?client=aff-360daohang",1, "client:aff-360daohang;hl:zh-CN"]
    ],
    news: [
        ["\u65b0\u95fb", "http://news.baidu.com/ns", "word", "\u767e\u5ea6", -1, "http://news.baidu.com/",1],
        ["\u8d44\u8baf", "http://news.google.cn/news/search", "q", "\u8c37\u6b4c", -29, "http://news.google.cn/?client=aff-360daohang",0, "client:aff-360daohang;hl:zh-CN;ie:utf-8"]
    ],
    video: [
        ["\u89c6\u9891", "http://video.baidu.com/v", "word", "\u767e\u5ea6", -1, "http://video.baidu.com/",1],
        ["\u89c6\u9891", "http://video.google.cn/videosearch", "q", "\u8c37\u6b4c", -29, "http://video.google.cn/?client=aff-360daohang",1, "client:aff-360daohang;hl:zh-CN"],
        ["", "http://movie.gougou.com/search", "search", "\u72d7\u72d7", -238, "http://movie.gougou.com/",1, "id:1"]
    ],
    wenda: [
        ["\u95ee\u7b54", "http://www.qihoo.com/wenda.php", "kw", "\u5947\u864e", -60, "http://www.qihoo.com/wenda.php",1, "do:search;area:0"],
        ["\u77e5\u9053", "http://zhidao.baidu.com/q", "word", "\u767e\u5ea6", -1, "http://zhidao.baidu.com",1, "ct:17;pt:360se_ik;tn:ikaslist"]
    ],
    shopping: [
        ["\u6dd8\u5b9d", "http://search8.taobao.com/browse/search_auction.htm", "q", "\u6dd8\u5b9d", -90, "http://www.taobao.com/?pid=mm_15144495_0_0",1, "pid:mm_15144495_0_0;search_type:auction;commend:all;at_topsearch:1;user_action:initiative;spercent:0;f:D9_5_1;sort:"],
        ["\u5f53\u5f53", "http://union.dangdang.com/transfer/transfer.aspx", "dd_key", "\u5f53\u5f53", -120, "http://union.dangdang.com/transfer/transfer.aspx?from=488-133054&backurl=http%3A%2F%2Fhome.dangdang.com",0, "from:488-133054;dd_catalog:01;backUrl:http%3A//search.dangdang.com/search.aspx%3Fkey%3D"],
        ["\u5353\u8d8a", "http://www.amazon.cn/search/search.asp", "searchWord", "\u5353\u8d8a", -150, "http://www.amazon.cn/?source=heima8_133054",0, "source:heima8_133054;Submit.x:7;Submit.y:9"],
        ["\u4eac\u4e1c", "http://www.360buy.com/union/SearchRedirect.aspx", "keyword", "\u4eac\u4e1c", -180, "http://union.360buy.com/union_default.aspx?union_Id=175",0, "union_Id:175"]
    ],
	map: [
        ["\u7f51\u9875", "http://map.baidu.com/#", "word", "\u767e\u5ea6", -1, "http://map.baidu.com/",1],
        ["\u7f51\u9875", "http://ditu.google.com/maps", "q", "\u8c37\u6b4c", -29, "http://www.google.com/",1, "hl:zh-CN;ie:utf-8"]
    ],
	tanzhi: [
        ["\u7f51\u9875", "http://map.baidu.com/#", "word", "\u767e\u5ea6", -1, "http://map.baidu.com/",1],
        ["\u7f51\u9875", "http://ditu.google.com/maps", "q", "\u8c37\u6b4c", -29, "http://www.google.com/",0, "hl:zh-CN;ie:utf-8"]
    ]		
}
//iframe包含
if (top.location != location) {
	top.location.href = location.href;
}

function $obj(id) {
	return document.getElementById(id);
}
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
function trim(str) { 
	var re = /\s*(\S[^\0]*\S)\s*/; 
	re.exec(str); 
	return RegExp.$1; 
}

function display(id) {
	var obj = $obj(id);
	obj.style.display = obj.style.display == '' ? 'none' : '';
}
function setDisplay(a, b){
	if ($("#"+a)) 
		$("#"+a).css({"display":(b ? "block" : "none")});
};
function urlto(url) {
	window.location.href = url;
}

function explode(sep, string) {
	return string.split(sep);
}
function copyToClipBoard(clipBoardContent){
    window.clipboardData.setData("Text",clipBoardContent); 
    alert("地址已经复制成功，您可以粘贴到其他需要的地方！"); 
} 
/*search*/
function googleHint(a) {
	if($("#gsuggest"))
		$("#gsuggest").remove();
    var b = document.body.appendChild(document.createElement("script"));
    b.language = "javascript";
    b.id = "gsuggest";
    b.charset = "utf-8";
    b.src = "http://www.google.cn/complete/search?hl=zh-CN&client=suggest&js=true&q=" + encodeURIComponent(a)
}
function myhint(a) {
	
    var b = $obj("searchkey"),
        c = $obj("sts");
    if (!b.value || !b.value.length || a.keyCode == 27 || a.keyCode == 13) c.style.display = "none";
    else if (a.keyCode == 38 || a.keyCode == 40) {
            if (c.style.display != "none") {
                if (a.keyCode == 38) if (c._i == -1) c._i = c.firstChild.rows.length - 1;
                else c._i--;
                else c._i++;
                for (a = 0; a < c.firstChild.rows.length; a++) c.firstChild.rows[a].style.background = "#FFF";
                if (c._i >= 0 && c._i < c.firstChild.rows.length) with(c.firstChild.rows[c._i]) {
                    style.background = "#E6E6E6";
                    b.value = cells[0].attributes._h.value
                } else {
                    b.value = c._kw;
                    c._i = -1
                }
            }
        } else {
            c._i = -1;
            c._kw = b.value;
            googleHint(b.value);
            with(c.style) width = b.offsetWidth - 2
        }
}
window.google = {};
window.google.ac = {};
window.google.ac.h = function (a) {
	if(!a||(a.length == 2 || a.length == 3))
		return;
	if (a[0] == $("#searchkey").val()) {
        var b = "";
        a = a[1];
        for (var c = 0; c < a.length; c++) b += "<tr style=\"cursor:hand\" onmousedown=\"$obj('searchkey').value='" + a[c][0] + '\';" onmouseover="javascript:this.style.background=\'#E6E6E6\'" onmouseout="javascript:this.style.background=\'#FFF\';"><td style="color:#000;font-size:12px;" align="left" _h="' + a[c][0] + '">' + a[c][0] + "</td></tr>";
        $obj("sts").innerHTML = '<table width="100%" border="0" cellpadding="0" cellspacing="0">' + b + "</table>";
        $("#sts").css("display","block");
    }
}

function getSearchTabCookieName() {
        return "tanzhi_search";
}
function  categoryShow(value) {
	$('#tb_bookmark').css("visibility",value?"visible":"hidden");
}
function email_validate(value)
{
	return /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(trim(value));
}
function url_validate(value)
{
	return  /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(trim(value));
}
function number_validate(value)
{
	return /^\d+$/.test(trim(value));
}
function range_validate(value,min,max)
{
	return ((/^\d+$/.test(trim(value)))&&(parseInt(value)<=max)&&(parseInt(value)>=min));
}
function illegachar_validate(value)
{
   return /[\\/:*?\"<>|]/i.test(trim(value)) ; 
}
function maxlen_validate(value,max)
{
  return(strlen(trim(value))<=max);
}
function rangelen_validate(value,min,max)
{
  return((strlen(trim(value))<=max)&&(strlen(trim(value))>=min));
}
function getLength(value)
{
	value=trim(value)
	var length = value.length;
    for(var i = 0; i < value.length; i++){
        if(value.charCodeAt(i) > 127){
            length++;
        }
    }
	return length;
}

function check_subject(id, min, max, specialchar)
{
	if ($('#'+id)) {
		if(!rangelen_validate($('#'+id).val(),min,max))    	
		{
            warning((id+'_tip'),"标题长度("+min+"~"+max+"字符)不符合要求");
            return false;
        }
		if(!specialchar&&illegachar_validate($(id).value))//不支持特殊字符
		{
		   warning((id+'_tip'),"标题不允许含有特殊字符");
		   return false;
		}	
    }
	return true;
}
function check_tag(id, min, max)
{
	if ($('#'+id)) {
		if(!rangelen_validate($('#'+id).val(),min,max))    	
		{
            warning((id+'_tip'),"标签("+min+"~"+max+"字符)不符合要求");
            return false;
        }
		if(illegachar_validate($('#'+id).val()))//不支持特殊字符
		{
		   warning((id+'_tip'),"标签不允许含有特殊字符");
		   return false;
		}
	
    }
	return true;
}
function check_description(id, min, max)
{
	if ($('#'+id)) {
		if(!rangelen_validate($('#'+id).val(),min,max))    	
		{
            warning((id+'_tip'),"描述("+min+"~"+max+"字符)不符合要求");
            return false;
        }
    }
	return true;
}

function check_url(id, min, max)
{
	if ($('#'+id)) {
		if(!url_validate($('#'+id).val())||!rangelen_validate($obj('address').value,min,max))    	
			{
				warning((id+'_tip'),"网址("+min+"~"+max+"字符)不符合要求");
				return false;
			}
		
    }
	return true;
}
function check_seccode(obj,id)
{
	if($('#'+id)) {
		$.ajax({
			  type: "GET",
			  url:'cp.php?ac=common&op=seccode&inajax=1&code='+$('#'+id).val(),
			  success:function(data){
				s=trim($(data).find('root').text());
				if(s.indexOf('succeed') == -1) {
					 warning('checkseccode',s);
					 blur();
           			 return false;
				}else {
					obj.form.submit();
					return true;
				}
			  }
		});
    }else{
		obj.form.submit();
		return true;
	}
}
function check_number(id,min,max)
{
	if ($('#'+id)) {
		if(!range_validate($('#'+id).val(),min,max))    	
			{
				warning((id+'_tip'),"请填写一个("+min+"~"+max+")之间的整数合要求");
				return false;
			}
    }
	return true;
}
function check_email(id)
{
	if ($('#'+id)) {
		if(!email_validate($('#'+id).val()))    	
			{
				warning((id+'_tip'),"请填写一个合法的email地址");
				return false;
			}
    }
	return true;
}
function bookmark_validate(obj,seccode_id, subjectlen, dirlen, urlen, specialchar) {
	var    titlelen=subjectlen;
	var	   isdir=$('input:radio[@name=category][@checked]').val();
	if(isdir)
		titlelen=dirlen; 
	if(!check_subject('subject', 1, titlelen, specialchar)||((!isdir)&&!check_url('address',1,urlen)))
		return false;
    if(!check_seccode(obj,seccode_id))
	    return false;
	return true;
}
function announce_validate(formobj,seccode_id) {
   if(!check_seccode(formobj,seccode_id))
	    return false;
	return true;
}
function link_validate(obj,seccode_id, subjectlen,  urlen, specialchar) {

	if(!check_subject('subject',1,subjectlen, specialchar)||!check_url('address',1,urlen)||!check_number('initaward',5000,9900))
			return false;
	if(!check_seccode(obj,seccode_id))
	    return false;
	return true;   
}
function report_validate(obj) {
	if(!check_seccode(obj,'seccode'))
	    return false;
	return true;
}

function login_validate(obj)
{
	if(!check_email('username'))
			return false;
	obj.submit();
   	return true;
}
function digg_validate(obj,seccode_id)
{
	if(!check_subject('subject', 1, 80, 1))
		return false;
	if(!check_url('address',1,512))
		return false;
	if(!check_tag('tag', 1, 20, 0))
		return false;
	if(!check_description('description', 10, 200, 1))
		return false;

	if(!check_seccode(obj,seccode_id))
	    return false;
	return true;
}

/*menu*/
function initMenuEx() {
    $('#menu ul').hide();
    $('.showit').each(
    function() {
        var obj = $(this);
        $(this).show();
        obj.parents('ul').each(function() {
            $(this).show();
        });
    });
    $('#menu li a').click( function() {
        var obj = $(this);
        $('#menu li a').removeClass('green');
        $('#menuroot').removeClass('green');
        obj.addClass('green');
        if (1) {
            $('#menu ul:visible').each(function() {
                var id = $(this).attr('id');
                var isParent = 0;
                obj.parents('ul').each(function() {
                    if (id == $(this).attr('id')) {
                        isParent = 1;
                    }
                });
                if (!isParent) $(this).slideUp('normal');
            });
        }
        var cE = $(this).next();
        if ((cE.is('ul')) && (cE.is(':visible'))) {
            cE.slideUp('normal');
        }

        if ((cE.is('ul')) && (!cE.is(':visible'))) {
            $('#menu ul:visible').each(function() {
                var id = $(this).attr('id');
                var isParent = 0;
                cE.parents('ul').each(function() {
                    if (id == $(this).attr('id')) isParent = 1;
                });
                if (!isParent) {
                    $(this).slideUp('normal');

                }
            });
            cE.slideDown('normal');
        }
    });
}
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
		$("#bklist >li >h3 >a").attr("style","float:left;max-width:200px;overflow:hidden;");

		$("#bklist .edit").each(function(){
			$(this).addClass("thickbox");
//			this.href="cp.php?ac=bookmark&bmid=189&groupid=0&browserid=1&op=edit"; 
			this.href = "cp.php?ac=bookmark&bmid="+this.id+"&groupid="+gpid+"&browserid="+bsid+"&op=edit&inajax=1";			
			//$(this).attr("onclick",
			//	"ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);");
//			this.id="bookmark_edit_"+this.id;
		});	
		$("#bklist .delete").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=bookmark&bmid="+this.id+"&groupid="+gpid+"&browserid="+bsid+"&op=delete&inajax=1&height=85";
			//this.id="bookmark_delete_"+this.id;
			//$(this).attr("onclick","ajaxmenu(event, this.id,1)");
		});	
		$("#bklist .get").each(function(){
			this.href="cp.php?ac=bookmark&op=get&bmid="+this.id;
		});	
		$("#bklist .url").each(function(){
			$(this).attr("onclick","updatestatics('bookmark','updatebookmarkview',"+this.id+")");
		});	
		
		$("#bklist a").attr("target","_blank");
		
		$(".id_bm_tag").each(function(){
			this.href = "javascript:;";
			$(this).attr("onclick","getAjax('bmtagview',"+this.id+");").attr("target","_self");
		});	

		$("#bklist .share").each(function(){
			this.href="javascript:void(0)";
			$(this).attr("onclick","updatebookmarkup("+this.id+")").attr("target","_self");
		});	
		$("#bklistt > li:even").addClass("list_r");;
		$("#bklist .delete").html("删除");
		$("#bklist .share").html("分享");
		$("#bklist .edit").html("编辑");
		$("#bklist .get").html("详情");
		tb_init('#bklist a.thickbox');
}
function siteload(){
		$(".id_nodes").each(function(){
			$(this).html("暂时没有对&nbsp;<a class=\"url id_st_"+this.id+"\" id=\""+this.id+"\"></a>&nbsp;的描述，你可以点击<a class=\"edit id_st_edit_"+this.id+"\" id=\""+this.id+"\">编辑</a>按钮或者等待服务器更新 ...");
		});
		$("#stlist >li >h3 >a").attr("style","float:left;width:250px;overflow:hidden;");
		$(".id_st_tag").each(function(){
			this.href = "space.php?do=sitetag&tagid=" + this.id;
		});	
		$("#stlist .edit").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=edit&inajax=1";			
			//$(this).attr("onclick","ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);");
			//this.id="bookmark_edit2_"+this.id;
		});	
		$("#stlist .delete").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=delete&inajax=1&height=85";
		//	this.id="bookmark_delete_"+this.id;
		//	$(this).attr("onclick","ajaxmenu(event, this.id,1)");
		});	
		$("#stlist .bm").each(function(){
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=bookmark";
			this.id="bookmark_edit2_"+this.id;
		});	
		$("#stlist .get").each(function(){
			this.href="cp.php?ac=site&op=get&siteid="+this.id;
		});	
		$("#stlist .url").each(function(){
			$(this).attr("onclick","updatestatics('site','updatesiteviewnum',"+this.id+")");
		});			
		$("#stlist a").attr("target","_blank");
		$("#stlist .tags > span").html("什么也没留下...");
		$("#stlist .collect").each(function(){
			this.href="cp.php?ac=site&op=bookmark&siteid="+this.id;			
		});
		$("#stlist > li:even").addClass("list_r");
		$("#stlist .delete").html("删除");
		$("#stlist .edit").html("编辑");
		$("#stlist .get").html("详情");
		$("#stlist .collect").html("收藏");
		tb_init('#stlist a.thickbox');
}

function diggload(){
		$(".id_dg_tag").each(function(){
			this.href = "space.php?do=diggtag&tagid=" + this.id;
		});	
		$(".tlist .edit").each(function(){
			$(this).addClass("thickbox");
			$(this).attr("href","cp.php?ac=digg&op=edit&height=700&inajax=1&diggid="+this.id).attr("target","_blank");
			//.attr("id","digg_edit_"+this.id);
		
		//	$(this).attr("onclick","ajaxmenuEx(event,'img_seccode_"+this.id+"', this.id,1);").attr("href","cp.php?ac=digg&op=edit&diggid="+this.id).attr("id","digg_edit_"+this.id);
		});	
		$(".tlist .delete").each(function(){
			$(this).addClass("thickbox");
			//$(this).attr("onclick","ajaxmenu(event,this.id,1)").attr("href","cp.php?ac=digg&op=delete&diggid="+this.id).attr("id","digg_delete_"+this.id);
			$(this).attr("href","cp.php?ac=digg&op=delete&inajax=1&height=85&diggid="+this.id);
		});	
		$(".tlist .up").each(function(){
			$(this).attr("href","javascript:void(0)").attr("onclick","updatediggup("+this.id+")").attr("target","_self");
		});	
		$(".tlist .down").each(function(){
			$(this).attr("href","javascript:void(0)").attr("onclick","updatediggdown("+this.id+")").attr("target","_self");
		});	
		$(".tlist .delete").html("删除");
		$(".tlist .edit").html("编辑");
		tb_init('.tlist a.thickbox');
}
function navtabload()
{
		$(".navtab").html($(".navtab_x").html());
		$(".navtab_x").remove();
		$(".navtab").addClass("ntitle"); 
		$(".nav_tab .navc").each(function(){
				$(this).attr("onclick","getAjax('siteview','"+this.id+"');$('.nav_tab li').removeClass('nav_on');$(this).parent().addClass('nav_on');");
				$(this).attr("href","javascript:;");
			});
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
			currentid= Cookie.get(getSearchTabCookieName());
			$(".shaa span").click(function(){
				$(".shaa span").removeClass("currentx");  
				$(this).addClass("currentx"); 
				$('#shfm input[type=checkbox]').remove();
				$('#shfm span').remove();

				$("#hidden_form").empty();
				var i=0;
				//setSearchTab($(this).attr("id"));
				Cookie.set(getSearchTabCookieName(), $(this).attr("id"), 1E3 * 3600 * 24 * 5);
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
			$("#hhlt p span").css("cursor","pointer");
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
$(function(){
       		initMenuEx();			
});
document.onclick = qkmu_close;
