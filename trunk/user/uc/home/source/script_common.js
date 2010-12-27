var userAgent = navigator.userAgent.toLowerCase();
var is_opera = userAgent.indexOf('opera') != -1 && opera.version();
var is_moz = (navigator.product == 'Gecko') && userAgent.substr(userAgent.indexOf('firefox') + 8, 3);
var is_ie = (userAgent.indexOf('msie') != -1 && !is_opera) && userAgent.substr(userAgent.indexOf('msie') + 5, 3);
var is_safari = (userAgent.indexOf('webkit') != -1 || userAgent.indexOf('safari') != -1);
var note_step = 0;
var note_oldtitle = document.title;
var note_timer;
var searchs = {
    web: [
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

Cookie = {	
	get: function(key) {
		tmp =  document.cookie.match((new RegExp(key +'=[a-zA-Z0-9.()=|%/]+($|;)','g')));
		if(!tmp || !tmp[0]) return null;
		else return unescape(tmp[0].substring(key.length+1,tmp[0].length).replace(';','')) || null;
		
	},	
	set: function(key, value, ttl, path, domain, secure) {
		cookie = [key+'='+    escape(value),
		 		  'path='+    ((!path   || path=='')  ? '/' : path),
		 		  'domain='+  ((!domain || domain=='')?  window.location.hostname : domain)];
		
		if (ttl)         cookie.push('expires='+Cookie.hoursToExpireDate(ttl));
		if (secure)      cookie.push('secure');
		return document.cookie = cookie.join('; ');
	},
	unset: function(key, path, domain) {
		path   = (!path   || typeof path   != 'string') ? '' : path;
        domain = (!domain || typeof domain != 'string') ? '' : domain;
		if (Cookie.get(key)) Cookie.set(key, '', 'Thu, 01-Jan-70 00:00:01 GMT', path, domain);
	},

	hoursToExpireDate: function(ttl) {
		if (parseInt(ttl) == 'NaN' ) return '';
		else {
			now = new Date();
			now.setTime(now.getTime() + (parseInt(ttl) * 60 * 60 * 1000));
			return now.toGMTString();			
		}
	},

	test: function() {
		Cookie.set('ca761231ed4211cebacd00aa0057b223', 'true');
		if (Cookie.get('ca761231ed4211cebacd00aa0057b223') == 'true') {
			Cookie.unset('ca761231ed4211cebacd00aa0057b223');
			return true;
		}
		return false;
	},	

	dump: function() {
		if (typeof console != 'undefined') {
			console.log(document.cookie.split(';'));
		}
	}
}
/**
 * jQuery.timers - Timer abstractions for jQuery
**/	
jQuery.fn.extend({
	everyTime: function(interval, label, fn, times) {
		return this.each(function() {
			jQuery.timer.add(this, interval, label, fn, times);
		});
	},
	oneTime: function(interval, label, fn) {
		return this.each(function() {
			jQuery.timer.add(this, interval, label, fn, 1);
		});
	},
	stopTime: function(label, fn) {
		return this.each(function() {
			jQuery.timer.remove(this, label, fn);
		});
	}
});

jQuery.extend({
	timer: {
		global: [],
		guid: 1,
		dataKey: "jQuery.timer",
		regex: /^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,
		powers: {
			// Yeah this is major overkill...
			'ms': 1,
			'cs': 10,
			'ds': 100,
			's': 1000,
			'das': 10000,
			'hs': 100000,
			'ks': 1000000
		},
		timeParse: function(value) {
			if (value == undefined || value == null)
				return null;
			var result = this.regex.exec(jQuery.trim(value.toString()));
			if (result[2]) {
				var num = parseFloat(result[1]);
				var mult = this.powers[result[2]] || 1;
				return num * mult;
			} else {
				return value;
			}
		},
		add: function(element, interval, label, fn, times) {
			var counter = 0;
			
			if (jQuery.isFunction(label)) {
				if (!times) 
					times = fn;
				fn = label;
				label = interval;
			}
			
			interval = jQuery.timer.timeParse(interval);

			if (typeof interval != 'number' || isNaN(interval) || interval < 0)
				return;

			if (typeof times != 'number' || isNaN(times) || times < 0) 
				times = 0;
			
			times = times || 0;
			
			var timers = jQuery.data(element, this.dataKey) || jQuery.data(element, this.dataKey, {});
			
			if (!timers[label])
				timers[label] = {};
			
			fn.timerID = fn.timerID || this.guid++;
			
			var handler = function() {
				if ((++counter > times && times !== 0) || fn.call(element, counter) === false)
					jQuery.timer.remove(element, label, fn);
			};
			
			handler.timerID = fn.timerID;
			
			if (!timers[label][fn.timerID])
				timers[label][fn.timerID] = window.setInterval(handler,interval);
			
			this.global.push( element );
			
		},
		remove: function(element, label, fn) {
			var timers = jQuery.data(element, this.dataKey), ret;
			
			if ( timers ) {
				
				if (!label) {
					for ( label in timers )
						this.remove(element, label, fn);
				} else if ( timers[label] ) {
					if ( fn ) {
						if ( fn.timerID ) {
							window.clearInterval(timers[label][fn.timerID]);
							delete timers[label][fn.timerID];
						}
					} else {
						for ( var fn in timers[label] ) {
							window.clearInterval(timers[label][fn]);
							delete timers[label][fn];
						}
					}
					
					for ( ret in timers[label] ) break;
					if ( !ret ) {
						ret = null;
						delete timers[label];
					}
				}
				
				for ( ret in timers ) break;
				if ( !ret ) 
					jQuery.removeData(element, this.dataKey);
			}
		}
	}
});

jQuery(window).bind("unload", function() {
	jQuery.each(jQuery.timer.global, function(index, item) {
		jQuery.timer.remove(item);
	});
});
var ajaxtypes = {
    bmview: [ ["space.php?do=bookmark&op=#","bmcontent"] ],
	siteview: [ ["space.php?do=navigation&classid=#","bmcontent"] ],
	bmtagview: [ ["space.php?do=linktag&tagid=#","bmcontent"] ],
	browserview: [ ["space.php?do=bookmark&op=browser&browserid=#","bmcontent"] ],
	dirtree: [ ["space.php?do=browser&op=show&browserid=#","browserdirtree"] ],
	bookmarkpage: [ ["space.php?do=bookmark&op=browser&groupid=#&browserid=#&page=#","bmcontent"] ],
	diggpage: [ ["space.php?do=digg&show=#&page=#","diggcontent"] ],
	sitepage: [ ["space.php?do=navigation&classid=#&child=#&page=#","bmcontent"] ],
	siterelate: [ ["cp.php?ac=site&op=relate&siteid=#","rdsect"] ] 
};
function getAjax(type,id)
{
	var ids = id.split('|');
	var urls = ajaxtypes[type][0][0];
	for(i=0;i<ids.length;i++)
	{
		urls=urls.replace(/#/, ids[i]);
	}
	$.ajax({
			  type: "GET",
			  url:urls+"&inajax=1",
			  success:function(s){
				if($('#'+ajaxtypes[type][0][1]))
					$('#'+ajaxtypes[type][0][1]).html($(s).find('root').text());
				//executeScript($(data).find('root').text());
			  }
	});
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
	if($('#img_seccode')) {
		$('#img_seccode').attr({ 
          src: img
        });
	}
}
function updateseccodeex(id) {
	var img = 'do.php?ac=seccode&rand='+Math.random();
	if($('#'+id)) {
		$('#'+id).attr({ 
          src: img
        });
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
	$('#'+id).css('display',($('#'+id).css('display')=='')?'none' : '');
}
function setDisplay(a, b){
	if ($("#"+a).length>0) 
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
function fSetTag(tag)
{
	if(!strlen($('#tag').val()))
		$('#tag').val(tag+' ');
	else
			$('#tag').val($('#tag').val()+' '+tag);
}
/*search*/
function googleHint(a) {
	if($("#gsuggest").length>0)
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
	if ($('#'+id).length>0) {
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
	if ($('#'+id).length>0) {
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
	if ($('#'+id).length>0) {
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
	if ($('#'+id).length>0) {
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
function edit_album_show(id) {
	var obj = $obj('tanzhi-edit-'+id);
	if(obj.style.display == '') {
		obj.style.display = 'none';
	} else {
		obj.style.display = '';
	}
}
function digg_submit(obj)
{
	mainForm = obj.form;
	forms = $obj('attachbody').getElementsByTagName("FORM");
	albumid = $obj('uploadalbum').value;
	upload();
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
/*
	if(!check_seccode(obj,seccode_id))
	    return false;
*/
	if($('#'+seccode_id)) {
		$.ajax({
			  type: "GET",
			  url:'cp.php?ac=common&op=seccode&inajax=1&code='+$('#'+seccode_id).val(),
			  success:function(data){
				s=trim($(data).find('root').text());
				if(s.indexOf('succeed') == -1) {
					 warning('checkseccode',s);
					 blur();
           			 return false;
				}else {
						digg_submit(obj);;
					return true;
				}
			  }
		});
    }else{
		obj.form.submit();
		return true;
	}
	return true;
}
/*thickbox*/
$(function(){   
	imgLoader = new Image();// preload image
	imgLoader.src = "template/default/image/ajax-loader.gif";
});
function tb_init(domChunk){
	$(domChunk).click(function(){
	var t = this.title || this.name || null;
	var a = this.href || this.alt;
	var g = this.rel || false;
	var ids = this.id.split("|");
	tb_show(t,a,g,ids[0]);
	this.blur();
	return false;
	});
}

function tb_show(caption, url, imageGroup,secode_id) {//function called when the user clicks on a thickbox link

	try {
		if (typeof document.body.style.maxHeight === "undefined") {//if IE 6
			$("body","html").css({height: "100%", width: "100%"});
			$("html").css("overflow","hidden");
			if (document.getElementById("TB_HideSelect") === null) {//iframe to hide select elements in ie6
				$("body").append("<iframe id='TB_HideSelect'></iframe><div id='TB_overlay'></div><div id='TB_window'></div>");
				$("#TB_overlay").click(tb_remove);
			}
		}else{//all others
			if(document.getElementById("TB_overlay") === null){
				$("body").append("<div id='TB_overlay'></div><div id='TB_window'></div>");
				$("#TB_overlay").click(tb_remove);
			}
		}
		
		if(tb_detectMacXFF()){
			$("#TB_overlay").addClass("TB_overlayMacFFBGHack");//use png overlay so hide flash
		}else{
			$("#TB_overlay").addClass("TB_overlayBG");//use background and opacity
		}
		
		if(caption===null){caption="";}
		$("body").append("<div id='TB_load'><img src='"+imgLoader.src+"' /></div>");//add loader to the page
		$('#TB_load').show();//show loader
		
		var baseURL;
	   if(url.indexOf("?")!==-1){ //ff there is a query string involved
			baseURL = url.substr(0, url.indexOf("?"));
	   }else{ 
	   		baseURL = url;
	   }
	   
	   var urlString = /\.jpg$|\.jpeg$|\.png$|\.gif$|\.bmp$/;
	   var urlType = baseURL.toLowerCase().match(urlString);

		if(urlType == '.jpg' || urlType == '.jpeg' || urlType == '.png' || urlType == '.gif' || urlType == '.bmp'){//code to show images
				
			TB_PrevCaption = "";
			TB_PrevURL = "";
			TB_PrevHTML = "";
			TB_NextCaption = "";
			TB_NextURL = "";
			TB_NextHTML = "";
			TB_imageCount = "";
			TB_FoundURL = false;
			if(imageGroup){
				TB_TempArray = $("a[@rel="+imageGroup+"]").get();
				for (TB_Counter = 0; ((TB_Counter < TB_TempArray.length) && (TB_NextHTML === "")); TB_Counter++) {
					var urlTypeTemp = TB_TempArray[TB_Counter].href.toLowerCase().match(urlString);
						if (!(TB_TempArray[TB_Counter].href == url)) {						
							if (TB_FoundURL) {
								TB_NextCaption = TB_TempArray[TB_Counter].title;
								TB_NextURL = TB_TempArray[TB_Counter].href;
								TB_NextHTML = "<span id='TB_next'>&nbsp;&nbsp;<a href='#'>Next &gt;</a></span>";
							} else {
								TB_PrevCaption = TB_TempArray[TB_Counter].title;
								TB_PrevURL = TB_TempArray[TB_Counter].href;
								TB_PrevHTML = "<span id='TB_prev'>&nbsp;&nbsp;<a href='#'>&lt; Prev</a></span>";
							}
						} else {
							TB_FoundURL = true;
							TB_imageCount = "Image " + (TB_Counter + 1) +" of "+ (TB_TempArray.length);											
						}
				}
			}

			imgPreloader = new Image();
			imgPreloader.onload = function(){		
			imgPreloader.onload = null;
				
			// Resizing large images - orginal by Christian Montoya edited by me.
			var pagesize = tb_getPageSize();
			var x = pagesize[0] - 150;
			var y = pagesize[1] - 150;
			var imageWidth = imgPreloader.width;
			var imageHeight = imgPreloader.height;
			if (imageWidth > x) {
				imageHeight = imageHeight * (x / imageWidth); 
				imageWidth = x; 
				if (imageHeight > y) { 
					imageWidth = imageWidth * (y / imageHeight); 
					imageHeight = y; 
				}
			} else if (imageHeight > y) { 
				imageWidth = imageWidth * (y / imageHeight); 
				imageHeight = y; 
				if (imageWidth > x) { 
					imageHeight = imageHeight * (x / imageWidth); 
					imageWidth = x;
				}
			}
			// End Resizing
			
			TB_WIDTH = imageWidth + 30;
			TB_HEIGHT = imageHeight + 60;
			$("#TB_window").append("<a href='' id='TB_ImageOff' title='Close'><img id='TB_Image' src='"+url+"' width='"+imageWidth+"' height='"+imageHeight+"' alt='"+caption+"'/></a>" + "<div id='TB_caption'>"+caption+"<div id='TB_secondLine'>" + TB_imageCount + TB_PrevHTML + TB_NextHTML + "</div></div><div id='TB_closeWindow'><a href='#' id='TB_closeWindowButton' title='Close'>close</a> or Esc Key</div>"); 		
			
			$("#TB_closeWindowButton").click(tb_remove);
			
			if (!(TB_PrevHTML === "")) {
				function goPrev(){
					if($(document).unbind("click",goPrev)){$(document).unbind("click",goPrev);}
					$("#TB_window").remove();
					$("body").append("<div id='TB_window'></div>");
					tb_show(TB_PrevCaption, TB_PrevURL, imageGroup);
					return false;	
				}
				$("#TB_prev").click(goPrev);
			}
			
			if (!(TB_NextHTML === "")) {		
				function goNext(){
					$("#TB_window").remove();
					$("body").append("<div id='TB_window'></div>");
					tb_show(TB_NextCaption, TB_NextURL, imageGroup);				
					return false;	
				}
				$("#TB_next").click(goNext);
				
			}

			document.onkeydown = function(e){ 	
				if (e == null) { // ie
					keycode = event.keyCode;
				} else { // mozilla
					keycode = e.which;
				}
				if(keycode == 27){ // close
					tb_remove();
				} else if(keycode == 190){ // display previous image
					if(!(TB_NextHTML == "")){
						document.onkeydown = "";
						goNext();
					}
				} else if(keycode == 188){ // display next image
					if(!(TB_PrevHTML == "")){
						document.onkeydown = "";
						goPrev();
					}
				}	
			};
			
			tb_position();
			$("#TB_load").remove();
			$("#TB_ImageOff").click(tb_remove);
			$("#TB_window").css({display:"block"}); //for safari using css instead of show
			};
			
			imgPreloader.src = url;
		}else{//code to show html
			
			var queryString = url.replace(/^[^\?]+\??/,'');
			var params = tb_parseQuery( queryString );
			TB_WIDTH = (params['width']*1) + 30 || 540; //defaults to 630 if no paramaters were added to URL
			TB_HEIGHT = (params['height']*1) + 40 || 510; //defaults to 440 if no paramaters were added to URL
			ajaxContentW = TB_WIDTH - 30;
			ajaxContentH = TB_HEIGHT - 45;
			
			if(url.indexOf('TB_iframe') != -1){// either iframe or ajax window		
					urlNoQuery = url.split('TB_');
					$("#TB_iframeContent").remove();
					if(params['modal'] != "true"){//iframe no modal
						$("#TB_window").append("<div id='TB_title'><div id='TB_ajaxWindowTitle'>"+caption+"</div><div id='TB_closeAjaxWindow'><a href='#' id='TB_closeWindowButton' title='Close'>close</a> or Esc Key</div></div><iframe frameborder='0' hspace='0' src='"+urlNoQuery[0]+"' id='TB_iframeContent' name='TB_iframeContent"+Math.round(Math.random()*1000)+"' onload='tb_showIframe()' style='width:"+(ajaxContentW + 29)+"px;height:"+(ajaxContentH + 17)+"px;' > </iframe>");
					}else{//iframe modal
					$("#TB_overlay").unbind();
							$("#TB_window").append("<iframe frameborder='0' hspace='0' src='"+urlNoQuery[0]+"' id='TB_iframeContent' name='TB_iframeContent"+Math.round(Math.random()*1000)+"' onload='tb_showIframe()' style='width:"+(ajaxContentW + 29)+"px;height:"+(ajaxContentH + 17)+"px;'> </iframe>");
					}
			}else{// not an iframe, ajax
					if($("#TB_window").css("display") != "block"){
						if(params['modal'] != "true"){//ajax no modal
						$("#TB_window").append("<div id='TB_title'><div id='TB_ajaxWindowTitle'>"+caption+"</div><div id='TB_closeAjaxWindow'><a href='#' id='TB_closeWindowButton'>&nbsp;</a></div></div><div id='TB_ajaxContent' style='width:"+ajaxContentW+"px;height:"+ajaxContentH+"px'></div>");
						}else{//ajax modal
						$("#TB_overlay").unbind();
						$("#TB_window").append("<div id='TB_ajaxContent' class='TB_modal' style='width:"+ajaxContentW+"px;height:"+ajaxContentH+"px;'></div>");	
						}
					}else{//this means the window is already up, we are just loading new content via ajax
						$("#TB_ajaxContent")[0].style.width = ajaxContentW +"px";
						$("#TB_ajaxContent")[0].style.height = ajaxContentH +"px";
						$("#TB_ajaxContent")[0].scrollTop = 0;
						//$("#TB_ajaxWindowTitle").html(caption);
					}
			}
					
			$("#TB_closeWindowButton").click(tb_remove);
			
				if(url.indexOf('TB_inline') != -1){	
					$("#TB_ajaxContent").append($('#' + params['inlineId']).children());
					$("#TB_window").unload(function () {
						$('#' + params['inlineId']).append( $("#TB_ajaxContent").children() ); // move elements back when you're finished
					});
					tb_position();
					$("#TB_load").remove();
					$("#TB_window").css({display:"block"}); 
				}else if(url.indexOf('TB_iframe') != -1){
					tb_position();
					if($.browser.safari){//safari needs help because it will not fire iframe onload
						$("#TB_load").remove();
						$("#TB_window").css({display:"block"});
					}
				}else{
					$.ajax({
					  type: "GET",
					  url: url+'&inajax=1',
					  success: function(data) {
						 // call up the thickbox handler again / reinitialise the plugin
						 $("#TB_ajaxContent").html($(data).find('root').text());
						 if(secode_id!="")
								updateseccodeex('img_seccode_'+secode_id);
						 tb_position();
						 $("#TB_load").remove();
						 tb_init("#TB_ajaxContent a.thickbox");
						 $("#TB_window").css({display:"block"});
					  }
					});
				}
			
		}

		if(!params['modal']){
			document.onkeyup = function(e){ 	
				if (e == null) { // ie
					keycode = event.keyCode;
				} else { // mozilla
					keycode = e.which;
				}
				if(keycode == 27){ // close
					tb_remove();
				}	
			};
		}
		
	} catch(e) {
		//nothing here
	}
}

//helper functions below
function tb_showIframe(){
	$("#TB_load").remove();
	$("#TB_window").css({display:"block"});
}

function tb_remove() {
 	$("#TB_imageOff").unbind("click");
	$("#TB_closeWindowButton").unbind("click");
	$("#TB_window").fadeOut("fast",function(){$('#TB_window,#TB_overlay,#TB_HideSelect').trigger("unload").unbind().remove();});
	$("#TB_load").remove();
	if (typeof document.body.style.maxHeight == "undefined") {//if IE 6
		$("body","html").css({height: "auto", width: "auto"});
		$("html").css("overflow","");
	}
	document.onkeydown = "";
	document.onkeyup = "";
	return false;
}

function tb_position() {
$("#TB_window").css({marginLeft: '-' + parseInt((TB_WIDTH / 2),10) + 'px', width: TB_WIDTH + 'px'});
	if ( !(jQuery.browser.msie && jQuery.browser.version < 7)) { // take away IE6
		$("#TB_window").css({marginTop: '-' + parseInt((TB_HEIGHT / 2),10) + 'px'});
	}
}

function tb_parseQuery ( query ) {
   var Params = {};
   if ( ! query ) {return Params;}// return empty object
   var Pairs = query.split(/[;&]/);
   for ( var i = 0; i < Pairs.length; i++ ) {
      var KeyVal = Pairs[i].split('=');
      if ( ! KeyVal || KeyVal.length != 2 ) {continue;}
      var key = unescape( KeyVal[0] );
      var val = unescape( KeyVal[1] );
      val = val.replace(/\+/g, ' ');
      Params[key] = val;
   }
   return Params;
}

function tb_getPageSize(){
	var de = document.documentElement;
	var w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
	var h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;
	arrayPageSize = [w,h];
	return arrayPageSize;
}

function tb_detectMacXFF() {
  var userAgent = navigator.userAgent.toLowerCase();
  if (userAgent.indexOf('mac') != -1 && userAgent.indexOf('firefox')!=-1) {
    return true;
  }
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
function getbmfromid(groupid,browserid,name,isroot) {
	if(groupid==0)
	{
		$('#menuroot').addClass('green');
		$('#menu li a').removeClass('green');
		$('#menu ul').hide();
	}
	getAjax('bookmarkpage',groupid+'|'+browserid+'|0');
	if(groupid!=0&&isroot==0)
	{
		$('#groupdo').html('<li class="bkad"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="'+groupid+'" class="thickbox">增加</a></li><li class="bket"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=edit&height=180" id="'+groupid+'" class="thickbox">修改</a></li><li class="bkde"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=delete&height=120" id="'+groupid+'" class="thickbox">删除</a></li>');
	}
	else{
		$('#groupdo').html('<li class="bkad"><a class="thickbox" href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="'+groupid+'">增加</a></li>');
	}
	$('#groupname').html(name+'&raquo;');
	tb_init('#groupdo a.thickbox');
}
function setbookmarkgroupid(id)
{
	if(id==0)
	{
		$('#menuroot').addClass('green');
		$('#menu li a').removeClass('green');
		$('#menu ul').hide();
	}
	$obj('browsergroupid').value=id;
}
var updatestaticss = {
    bookmark: [ ["bmid"] ],
	site: [ ["siteid"] ],
	digg: [ ["diggid"] ]
};
function updatestatics(type,op,id,o)
{
		$.ajax({
			  type: "GET",
			  url:'cp.php?ac='+type+'&op='+op+'&inajax=1&'+updatestaticss[type][0][0]+'='+id,
			  success:function(data){
					s =	$(data).find('root').text();
					if((type=='bookmark')&&(op=='updatebookmarkupnum')){
						if(s.indexOf('error') == -1)
						{
							$('#share_bm_'+id).html('分享成功');
							if($('#'+o)) $('#'+o).html(s);
						}
						else
							 $('#share_bm_'+id).html('今天已分享'); 						
					   $('#share_bm_'+id).oneTime(1000, function() {
						$(this).html('');
						});
					}
					if((type=='site')&&((op=='updatesiteupnum')||(op=='updatesitedownnum'))){
						if(s.indexOf('error') == -1){
							 $('#site_ud_'+id).html('(感谢您的参与)');
							 if($('#'+o)) $('#'+o).html(s);
						}
						else
							 $('#site_ud_'+id).html('(今天您已参与)'); 						
					   $('#site_ud_'+id).oneTime(1000, function() {
						$(this).html('点击顶踩评价');
						});
					}
					if((type=='digg')&&((op=='updatediggupnum'))){
						if(s.indexOf('error') == -1){
							 $('#digg_ud_'+id).html('(感谢您的参与)');
							 if($('#'+o)) $('#'+o).html(s);
						}
						else
							 $('#digg_ud_'+id).html('(今天您已参与)'); 						
						$('#digg_ud_'+id).oneTime(1000, function() {
							$(this).html('');
						});
					}
			  }
		});
		//this.blur();
		return false;
} 

var lastSecCode='';
function checkSeccode() {
		var  seccodeVerify= $('#seccode').val();		
		if(seccodeVerify == lastSecCode) {
			return;
		} else {
			lastSecCode = seccodeVerify;
		}
		ajaxresponse('checkseccode', 'op=checkseccode&seccode=' + (is_ie && document.charset == 'utf-8' ? encodeURIComponent(seccodeVerify) : seccodeVerify));
}

function warning(id, msg) {
		$('#'+id).css('display','');
		$('#'+id).html('<img src="image/check_error.gif" width="13" height="13"> &nbsp; ' + msg);
		$('#'+id).addClass('warning');
}
function clearwarning(id){
		$('#'+id).css('display','none');
		$('#'+id).html('');		
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
		$("#bklist .edit").each(function(){
			$(this).addClass("thickbox");
			var ids = this.id.split("|");//ids='bmid_groupid_browserid'
			this.href = "cp.php?ac=bookmark&bmid="+ids[0]+"&groupid="+ids[1]+"&browserid="+ids[2]+"&op=edit";			
		});	
		$("#bklist .delete").each(function(){
			$(this).addClass("thickbox");
			var ids = this.id.split("|");
			this.href = "cp.php?ac=bookmark&bmid="+ids[0]+"&groupid="+ids[1]+"&browserid="+ids[2]+"&op=delete&height=95";
		});	
		/*
		$("#bklist .get").each(function(){
			this.href="cp.php?ac=bookmark&op=get&bmid="+this.id;
		});
		*/
		$("#bklist .url").each(function(){
			$(this).attr("onclick","updatestatics('bookmark','updatebookmarkview',"+this.id+")");
		});			
		$("#bklist a").attr("target","_blank");		
		$(".id_bm_tag").each(function(){
			this.href = "javascript:;";
			$(this).attr("onclick","getAjax('bmtagview','"+this.id+"');").attr("target","_self");
		});	
		$("#bklist .share").each(function(){
			$(this).attr({
				onclick:'updatestatics("bookmark","updatebookmarkupnum","'+this.id+'")',
				href:"javascript:void(0)",
				target:"_self"
			});

		});	
		$("#bklistt > li:even").addClass("list_r");;
		$("#bklist .delete").html("删除");
		$("#bklist .share").html("分享");
		$("#bklist .edit").html("编辑");
	//	$("#bklist .get").html("详情");
		tb_init('#bklist a.thickbox');
}
function siteload(){
		$(".id_nodes").each(function(){
			$(this).html("暂时没有对&nbsp;<a class=\"url id_st_"+this.id+"\" id=\""+this.id+"\"></a>&nbsp;的描述，你可以点击<a class=\"edit id_st_edit_"+this.id+"\" id=\""+this.id+"\">编辑</a>按钮或者等待服务器更新 ...");
		});
		$(".id_st_tag").each(function(){
			this.href = "space.php?do=sitetag&tagid=" + this.id;
		});	
		$("#stlist .edit").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=edit";			
		});	
		$("#stlist .delete").each(function(){
			$(this).addClass("thickbox");
			this.href = "cp.php?ac=site&siteid="+this.id+"&op=delete&height=95";
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
			$(this).attr("href","cp.php?ac=digg&op=edit&height=700&diggid="+this.id).attr("target","_blank");
		});	
		$(".tlist .delete").each(function(){
			$(this).addClass("thickbox");
			$(this).attr("href","cp.php?ac=digg&op=delete&height=85&diggid="+this.id);
		});
		$(".tlist .up").each(function(){
			$(this).attr({
				href:"javascript:;",
				onclick:"updatestatics('digg','updatediggupnum','"+this.id+"');"
			});
		});
		
		$(".tlist .up").html("推一下");
		$(".tlist .delete").html("删除");
		$(".tlist .edit").html("编辑");
		tb_init('.tlist a.thickbox');
}
function diggpoolload(){
		$(".tlist .delete").each(function(){
			$(this).addClass("thickbox");
			$(this).attr("href","cp.php?ac=diggpool&op=delete&height=85&diggpoolid="+this.id);
		});
		$(".tlist .publish").each(function(){
			$(this).addClass("thickbox");
			$(this).attr({				 				
				href:"cp.php?ac=diggpool&op=publish&height=85&diggpoolid="+this.id,
			});
		});
		
		$(".tlist .publish").html("发表");
		$(".tlist .delete").html("删除");
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
			currentid= Cookie.get("tanzhi_search");
			$(".shaa span").click(function(){
				$(".shaa span").removeClass("currentx");  
				$(this).addClass("currentx"); 
				$('#shfm input[type=checkbox]').remove();
				$('#shfm span').remove();
				$("#hidden_form").empty();
				var i=0;
				Cookie.set("tanzhi_search", $(this).attr("id"), 1E3 * 3600 * 24 * 5);
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
		if($('.shaa #'+currentid).length>0)
			{
				$('.shaa #'+currentid).click(); 
			}
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
