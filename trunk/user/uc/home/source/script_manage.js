/*
function linkclasstag_add(sid, result) {
	if(result) {
		//linkclassform_1=>linkclassform_1_tag
		var obj = $obj(sid+'_tag');
		var newli = document.createElement("h4");
		var x = new Ajax();
		x.get('do.php?ac=ajax&op=linkclasstag', function(s){
			newli.innerHTML = s;
		});
		obj.appendChild(newli);		
	}
}
function linkclass_add(sid, result) {
	if(result) {
		//linkclassform_1=>linkclassform_1_tag
		var obj = $obj(sid+'_name');
		var newli = document.createElement("h4");
		var x = new Ajax();
		x.get('do.php?ac=ajax&op=linkclass', function(s){
			newli.innerHTML = s;
		});
		obj.appendChild(newli);
		
	}
}

function  categoryShow(value) {
	$('#tb_bookmark').css("display",value?"":"none");
}
*/
/*search*/
function googleHint(a) {
	if($("#gsuggest"))
		$("#gsuggest").remove();
    var b = document.body.appendChild(document.createElement("script"));
    b.language = "javascript";
    b.id = "gsuggest";
    b.charset = "utf-8";
    b.src = "http://www.google.cn/complete/search?hl=zh-CN&client=suggest&js=true&q=" + encodeURIComponent(a)
};

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
};
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
};

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
		
		
};

function getSearchTabCookieName() {
        return "tanzhi_search"
};
/*
function setSearchTab(a) {
        //setCookie(getSearchTabCookieName(), a, 1E3 * 3600 * 24 * 5)
		Cookie.set(getSearchTabCookieName(), a, 1E3 * 3600 * 24 * 5);
    }

function getSearchTabByIndex(a) {
        a = a ? a : 0;
        a = getCookie(getSearchTabCookieName());
        if (a == null || a == "") return 1;
        return a
    };

function getCookie(a) {
     //   var b;
     //   var c = new RegExp("(^| )" + a + "=([^;]*)(;|$)");
     //   if (b = document.cookie.match(c)) return unescape(b[2]);
      //  else return null ;
		return Cookie.get(a);
    };

function setCookie(a, b) {
        var c = arguments[2] ? arguments[2] : 7 * 24 * 60 * 60 * 1000;
        var d = new Date;
        d.setTime(d.getTime() + c);
        var e = "tanzhi.com";
        document.cookie = a + "=" + escape(b); + ";expires=" + d.toGMTString() + ";path=/;domain=" + e ;
    };


function delCookie(a) {
        var b = -1,
            cval = getCookie(a);
        var c = new Date;
        c.setTime(c.getTime() + b);
        if (cval != null) {
                var d = "hao.360.cn";
                document.cookie = a + "=" + escape(cval) + ";expires=" + c.toGMTString() + ";path=/;domain=" + d;
                document.cookie = a + "=" + escape(cval) + ";expires=" + c.toGMTString() + ";path=/;"
            }
    };
*/

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
    $('#menu li a').click(
    function() {
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
/*validate*/

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
/*
 include UTF-8
*/
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
	if ($(id)) {
		if(!rangelen_validate($obj(id).value,min,max))    	
		{
            warning($obj(id+'_tip'),"标题长度("+min+"~"+max+"字符)不符合要求");
            return false;
        }
		if(!specialchar&&illegachar_validate($(id).value))//不支持特殊字符
		{
		   warning($obj(id+'_tip'),"标题不允许含有特殊字符");
		   return false;
		}
	
    }
	return true;
}
function check_tag(id, min, max)
{
	if ($(id)) {
		if(!rangelen_validate($obj(id).value,min,max))    	
		{
            warning($obj(id+'_tip'),"标签("+min+"~"+max+"字符)不符合要求");
            return false;
        }
		if(illegachar_validate($obj(id).value))//不支持特殊字符
		{
		   warning($obj(id+'_tip'),"标签不允许含有特殊字符");
		   return false;
		}
	
    }
	return true;
}
function check_description(id, min, max)
{
	if ($(id)) {
		if(!rangelen_validate($obj(id).value,min,max))    	
		{
            warning($obj(id+'_tip'),"描述("+min+"~"+max+"字符)不符合要求");
            return false;
        }
    }
	return true;
}

function check_url(id, min, max)
{
	if ($(id)) {
		if(!url_validate($obj(id).value)||!rangelen_validate($obj('address').value,min,max))    	
			{
				warning($obj(id+'_tip'),"网址("+min+"~"+max+"字符)不符合要求");
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
					 warning($obj('checkseccode'),s);
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
function check_seccode_x(formobj,id)
{
	if($(id)) {
		var code = $obj(id).value;
		var x = new Ajax();
		x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
			s = trim(s);
			if(s.indexOf('succeed') == -1) {
				 warning($obj('checkseccode'),s);
           		 return false;
			}else {
				formobj.submit();
				return true;
			}
		});
    }else{
		formobj.submit();
		return true;
	}
}
function check_number(id,min,max)
{
	if ($(id)) {
		if(!range_validate($obj(id).value,min,max))    	
			{
				warning($obj(id+'_tip'),"请填写一个("+min+"~"+max+")之间的整数合要求");
				return false;
			}
    }
	return true;
}
function check_email(id)
{
	if ($(id)) {
		if(!email_validate($obj(id).value))    	
			{
				warning($obj(id+'_tip'),"请填写一个合法的email地址");
				return false;
			}
    }
	return true;
}
function bookmark_validate(obj,seccode_id, subjectlen, dirlen, urlen, specialchar) {
	var    titlelen=subjectlen;
	var	   iscategory=0;
	if($obj('category')&&$obj('category').value==1) //dir
	{
		titlelen=dirlen; 
		iscategory=1;
	}
			
	if(!check_subject('subject', 1, titlelen, specialchar)||((!iscategory)&&!check_url('address',1,urlen)))
		return false;
	
    if(!check_seccode(obj,seccode_id))
	    return false;
	return true;
}
function announce_validate(formobj,seccode_id) {
   if(!check_seccode_x(formobj,seccode_id))
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
    if($obj('seccode')) {
		var code = $obj('seccode').value;
		var x = new Ajax();
		x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
			s = trim(s);
			if(s.indexOf('succeed') == -1) {
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
function linktoolbar_validate(obj)
{
	 if($obj('seccode')) {
		var code = $obj('seccode').value;
		var x = new Ajax();
		x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
			s = trim(s);
			if(s.indexOf('succeed') == -1) {
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
