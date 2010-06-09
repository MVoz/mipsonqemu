function googleHint(a) {
    getObj("gsuggest") && getObj("gsuggest").parentNode.removeChild(getObj("gsuggest"));
    var b = document.body.appendChild(document.createElement("script"));
    b.language = "javascript";
    b.id = "gsuggest";
    b.charset = "utf-8";
    b.src = "http://www.google.cn/complete/search?hl=zh-CN&client=suggest&js=true&q=" + encodeURIComponent(a)
};

function myhint(a) {
	
    var b = getObj("searchkey"),
        c = getObj("suggests");
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
    if (!(!a || a.length != 2 && a.length != 3)) if (a[0] == getObj("searchkey").value) {
        var b = "";
        a = a[1];
        for (var c = 0; c < a.length; c++) b += "<tr style=\"cursor:hand\" onmousedown=\"getObj('searchkey').value='" + a[c][0] + '\';javascript:searchSubmit(this);" onmouseover="javascript:this.style.background=\'#E6E6E6\'" onmouseout="javascript:this.style.background=\'#FFF\';"><td style="color:#000;font-size:12px;" align="left" _h="' + a[c][0] + '">' + a[c][0] + '</td><td style="color:#090" align="right" style="font-size:11.5px;">\u7ea6' + a[c][1] + "</td></tr>";
        getObj("suggests").innerHTML = '<table width="100%" border="0" cellpadding="0" cellspacing="0">' + b + "</table>";
        setDisplay("suggests", 1)
    }
};

function searchSubmit(a) {
    formInfo = a.parentNode.parentNode.parentNode.parentNode;
    if (formInfo.tagName == "FORM") {
        if (getObj("backUrl")) getObj("backUrl").value = "http%3A//search.dangdang.com/search.aspx%3Fkey%3D" + getObj("searchkey").value;
        formInfo.submit()
    }
};


var j;


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

function setSearchTab(a) {
        setCookie(getSearchTabCookieName(), a, 1E3 * 3600 * 24 * 5)
    }
function getSearchTabByIndex(a) {
        a = a ? a : 0;
        a = getCookie(getSearchTabCookieName());
        if (a == null || a == "") return 1;
        return a
    };
function getCookie(a) {
        var b;
        var c = new RegExp("(^| )" + a + "=([^;]*)(;|$)");
        if (b = document.cookie.match(c)) return unescape(b[2]);
        else return null ;
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
function getObj(a) {
        return document.getElementById(a)
    };

function setDisplay(a, b) {
        if (getObj(a)) getObj(a).style.display = b ? "block" : "none"
    };

