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

function getOldSearchTabCookieName() {
    return "schtab"
};

function getOldSearchTab() {
    var a = getCookie(getOldSearchTabCookieName());
    if (a == null || a == "") return false;
    var b = a.split(",");
    if (b[1] != 0) return false;
    if (b[0] > 1) return false;
    return b[0]
};

function highlightSearchTab() {
    var a = getSearchTabByIndex(0);
    var b = getOldSearchTab();
    if (b === false) displayTab("web_page", a);
    else {
        delCookie(getOldSearchTabCookieName());
        displayTab("web_page", b)
    }
};
var j;

function init() {
    var a = getObj("searchTab").getElementsByTagName("strong");
    j = a.length;
    for (var b = 0; b < j; b++) a[b].onclick = function () {
        if (this.id == getSearchTabCookieName()) {
            var a = getCookie(this.id);
            displayTab(this.id, a)
        } else displayTab(this.id, /(wenda|shopping)/.test(this.id)?0:1)
    }
};
var searchs = {
    web_page: [
        ["\u7f51\u9875", "http://www.baidu.com/s", "wd", "\u767e\u5ea6", -1, "http://www.baidu.com/index.php"],
        ["\u7f51\u9875", "http://www.google.cn/search", "q", "\u8c37\u6b4c", -29, "http://www.google.cn/webhp?client=aff-360daohang", "client:aff-360daohang;hl:zh-CN;ie:gb2312"]
    ],
    music: [
        ["MP3", "http://mp3.baidu.com/m", "word", "\u767e\u5ea6", -1, "http://mp3.baidu.com/", "f:ms;ct:134217728"],
        ["\u97f3\u4e50", "http://www.google.cn/music/search", "q", "\u8c37\u6b4c", -29, "http://www.google.cn/music/?client=aff-360daohang", "client:aff-360daohang;hl:zh-CN;ie:gb2312;oe:utf-8"],
        ["\u641c\u72d7", "http://mp3.sogou.com/music", "query", "\u641c\u72d7", -208, "http://mp3.sogou.com/"]
    ],
    image: [
        ["\u56fe\u7247", "http://image.baidu.com/i", "word", "\u767e\u5ea6", -1, "http://image.baidu.com/", "cl:2;lm:-1;ct:201326592"],
        ["\u56fe\u7247", "http://images.google.cn/images", "q", "\u8c37\u6b4c", -29, "http://images.google.cn/imghp?client=aff-360daohang", "client:aff-360daohang;hl:zh-CN"]
    ],
    news: [
        ["\u65b0\u95fb", "http://news.baidu.com/ns", "word", "\u767e\u5ea6", -1, "http://news.baidu.com/"],
        ["\u8d44\u8baf", "http://news.google.cn/news/search", "q", "\u8c37\u6b4c", -29, "http://news.google.cn/?client=aff-360daohang", "client:aff-360daohang;hl:zh-CN;ie:gbk"]
    ],
    video: [
        ["\u89c6\u9891", "http://video.baidu.com/v", "word", "\u767e\u5ea6", -1, "http://video.baidu.com/"],
        ["\u89c6\u9891", "http://video.google.cn/videosearch", "q", "\u8c37\u6b4c", -29, "http://video.google.cn/?client=aff-360daohang", "client:aff-360daohang;hl:zh-CN"],
        ["", "http://movie.gougou.com/search", "search", "\u72d7\u72d7", -238, "http://movie.gougou.com/", "id:1"]
    ],
    wenda: [
        ["\u95ee\u7b54", "http://www.qihoo.com/wenda.php", "kw", "\u5947\u864e", -60, "http://www.qihoo.com/wenda.php", "do:search;area:0"],
        ["\u77e5\u9053", "http://zhidao.baidu.com/q", "word", "\u767e\u5ea6", -1, "http://zhidao.baidu.com", "ct:17;pt:360se_ik;tn:ikaslist"]
    ],
    shopping: [
        ["\u6dd8\u5b9d", "http://search8.taobao.com/browse/search_auction.htm", "q", "\u6dd8\u5b9d", -90, "http://www.taobao.com/?pid=mm_15144495_0_0", "pid:mm_15144495_0_0;search_type:auction;commend:all;at_topsearch:1;user_action:initiative;spercent:0;f:D9_5_1;sort:"],
        ["\u5f53\u5f53", "http://union.dangdang.com/transfer/transfer.aspx", "dd_key", "\u5f53\u5f53", -120, "http://union.dangdang.com/transfer/transfer.aspx?from=488-133054&backurl=http%3A%2F%2Fhome.dangdang.com", "from:488-133054;dd_catalog:01;backUrl:http%3A//search.dangdang.com/search.aspx%3Fkey%3D"],
        ["\u5353\u8d8a", "http://www.amazon.cn/search/search.asp", "searchWord", "\u5353\u8d8a", -150, "http://www.amazon.cn/?source=heima8_133054", "source:heima8_133054;Submit.x:7;Submit.y:9"],
        ["\u4eac\u4e1c", "http://www.360buy.com/union/SearchRedirect.aspx", "keyword", "\u4eac\u4e1c", -180, "http://union.360buy.com/union_default.aspx?union_Id=175", "union_Id:175"]
    ]
};

function setSearchTabClass(a) {
    for (var b in searchs) getObj(b).className = b == a ? "bStyle" : ""
};

function searchChange(a, b) {
    getObj("hidpar").innerHTML = "";
    getObj("searchForm").action = searchs[a][b][1];
    getObj("searchkey").name = searchs[a][b][2];
    getObj("searchBtn").value = searchs[a][b][3] + "\u641c\u7d22";
    getObj("setUrl").style.backgroundPosition = "0 " + searchs[a][b][4] + "px";
    getObj("setUrl").href = searchs[a][b][5];
    setSearchTabClass(a)
};

function setSearchRadio(a, b) {
    var c = searchs[a],
        oSearch = getObj("selectId"),
        radioArr = [];
    for (var i = 0, len = c.length; i < len; i++) {
            radioArr[i] = '<label for="se' + i + '">' + "<input onclick=\"displayTab2('" + a + "'," + i + ')" ' + (i == b ? "checked" : "") + ' type="radio" name="searchRadio" id="se' + i + '"/>' + "<span>" + c[i][3] + "</span></label>"
        }
    oSearch.innerHTML = radioArr.join("")
};

function setSearchHidden(a, b) {
    if (searchs[a][b][6] != null) {
        var c = searchs[a][b][6].split(";");
        for (var d = 0, len = c.length; d < len; d++) {
            var e = c[d].split(":");
            var f = document.createElement("INPUT");
            f.type = "hidden";
            f.name = e[0];
            f.id = e[0];
            f.value = e[1];
            getObj("hidpar").appendChild(f)
        }
    }
    if (a == "shopping" && b == 1) getObj("searchForm").onsubmit = function () {
        if (getObj("backUrl")) {
            getObj("backUrl").value = "http%3A//search.dangdang.com/search.aspx%3Fkey%3D" + getObj("searchkey").value;
            return true
        }
    }
};

function displayTab(a, b) {
    searchChange(a, b);
    setSearchRadio(a, b);
    setSearchHidden(a, b);
    if (a == "web_page") setSearchTab(b)
};

function displayTab2(a, b) {
    searchChange(a, b);
    setSearchHidden(a, b);
    if (a == "web_page") setSearchTab(b)
};

function setPage() {
    if ("http://hao.360.cn/set.html" != getObj("setPageIfrm").src) getObj("setPageIfrm").src = "http://hao.360.cn/set.html";
    if ("none" == getObj("set").style.display) getObj("set").style.display = "";
    else getObj("set").style.display = "none"
};

function col() {
    getObj("setBt").className = "setBtn";
    getObj("set").style.display = "none"
};
var g_mode_standard = "0",
    g_mode_search = "1",
    g_mode_hao360 = "2";

function UseMode(a) {
        try {
            window.location.href = a === g_mode_search ? "se:home" : a === g_mode_hao360 ? "http://hao.360.cn" : "se:home"
        } catch (b) {}
    };

function SetUseMode(a) {
        try {
            var b = external.twGetSecurityID(window);
            b = external.SetOptionValue(b, "option", "UseSimple", a);
            UseMode(a)
        } catch (c) {}
    };

function GetUseMode() {
        try {
            var a = external.twGetSecurityID(window),
                b = external.GetOptionValue(a, "option", "UseSimple");
            if (b == null || b == "undefined" || b == "") b = g_mode_standard;
            return b
        } catch (c) {
            return g_mode_standard
        }
    };

function GetSeVer() {
        try {
            return external.twGetVersion(external.twGetSecurityID(window))
        } catch (a) {
            return "3.0.0.1"
        }
    };

function IsFromSehome() {
        if (window.location.href.indexOf("src=sehomeb") > 0) return true;
        return false
    };

function showSehomeMode() {
        try {
            if (GetSeVer() >= "3.1.0.3" && IsFromSehome() && getObj("semodeBox") != null) getObj("semodeBox").style.display = ""
        } catch (a) {}
    };

function getRight() {
        if (getCookie("360WEBPW") == 1) {
            getObj("setPageMenu").style.marginRight = screen.availWidth > 1020 && screen.availWidth < 1124 ? "136px" : "";
            getObj("set").style.right = screen.availWidth > 1020 && screen.availWidth < 1124 ? "136px" : ""
        }
    };

function getSearchTabCookieName() {
        return "web_page"
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
window.onload = function () {
     //   getRight();
    //    showSehomeMode()
    };
//init();
//highlightSearchTab();


function do_s() {
        var $ = getObj("keyword").value;
        var a = encodeURIComponent($);
        var b = document.getElementsByName("msrg");
        if (b[0].checked) window.open("http://www.baidu.com/s?ie=utf-8&wd=" + a);
        if (b[1].checked) window.open("http://www.google.cn/search?client=aff-360daohang&q=" + a);
        if (b[2].checked) window.open("http://www.qihoo.com/wenda.php?do=search&area=2&src=bbs&kw=" + $);
        if (b[3].checked) window.open("http://www.google.cn/books?client=aff-360daohang&q=" + a);
        if (b[4].checked) window.open("http://mp3.baidu.com/m?ie=utf-8&f=ms&ct=134217728&word=" + $);
        if (b[5].checked) window.open("http://video.gougou.com/search?id=&s=" + $);
        if (b[6].checked) window.open("http://movie.gougou.com/search?id=&search=" + $);
        if (b[7].checked) window.open("http://image.baidu.com/i?ie=utf-8&lm=-1&ct=201326592&word=" + a);
        if (b[8].checked) window.open("http://shenghuo.google.cn/shenghuo/search?client=aff-360daohang&q=" + a);
        if (b[9].checked) window.open("http://search8.taobao.com/browse/search_auction.htm?search_type=auction&commend=all&at_topsearch=1&user_action=initiative&q=" + $);
        if (b[10].checked) window.open("http://www.nciku.com/search/all/" + $);
        if (b[11].checked) window.open("http://ditu.google.cn/maps?q=" + a);
        if (b[12].checked) window.open("http://zhidao.baidu.com/q?tn=ikaslist&ct=17&pt=360se_ik&word=" + $);
        if (b[13].checked) window.open("http://soft.gougou.com/search?id=&client=aff-360daohang&search=" + $);
        return false
    }


function getObj(a) {
        return document.getElementById(a)
    };

function getCookie(a) {
        var b;
        var c = new RegExp("(^| )" + a + "=([^;]*)(;|$)");
        if (b = document.cookie.match(c)) return unescape(b[2]);
        else return null
    };

function setCookie(a, b) {
        var c = arguments[2] ? arguments[2] : 7 * 24 * 60 * 60 * 1000;
        var d = new Date;
        d.setTime(d.getTime() + c);
        var e = "hao.360.cn";
        document.cookie = a + "=" + escape(b) + ";expires=" + d.toGMTString() + ";path=/;domain=" + e
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

function setDisplay(a, b) {
        if (getObj(a)) getObj(a).style.display = b ? "block" : "none"
    };

function loadJs(a, b, c) {
        var d = document.getElementsByTagName("head")[0],
            oScript = null;
        if (getObj(a) == null) {
                oScript = document.createElement("script");
                oScript.setAttribute("type", "text/javascript");
                oScript.setAttribute("src", b);
                oScript.setAttribute("id", a);
                if (c != null) oScript.onload = oScript.onreadystatechange = function () {
                    if (oScript.ready) return false;
                    if (!oScript.readyState || oScript.readyState == "loaded" || oScript.readyState == "complete") {
                        oScript.ready = true;
                        c()
                    }
                };
                d.appendChild(oScript);
                return true
            } else {
                if (c != null) {
                    c();
                    return true
                }
                return false
            }
    };

function checkMail(a) {
        loadJs("mail_js", mailJsPath, function () {
            _s.check(a)
        });
        return false
    }; -
function () {
        var b = getObj('tag');
        b && (b.onclick = function (e) {
            e = e || event;
            var t = e.srcElement || e.target;
            if (/span|li/i.test(t.tagName)) {
                var a = t.id.match(/\d/)[0],
                    num = getObj("conBox").getElementsByTagName("div"),
                    urlArr = {
                        2: "http://rd.qihoo.com/qd.html?u=http%253A%252F%252Fhao.360.cn%252FgupiaocaipiaoTab.html&t=1264384954&c=1&a=9&p=6372&s=263bada48c52805af36481fbbf058558",
                        3: "http://rd.qihoo.com/qd.html?u=http%253A%252F%252Fhao.360.cn%252Fgametab.html&t=1265870776&c=1&a=9&p=6420&s=a13c6c167948b4dca16ab3d3a5c49304",
                        4: "http://d.hao.360.cn/listMyBookMark.php",
                        5: "http://hao.360.cn/unclosedlist2.html",
                        6: "http://rd.qihoo.com/qd.html?u=http%253A%252F%252Fhao.360.cn%252Fmzgouwutab.html&t=1264474024&c=1&a=9&p=6388&s=8449a9b186277cf90694fb0378b9f7f2",
                        7: "http://hao.360.cn/dailysoftware.html"
                    };
                for (var i = 1; i <= num.length; i++) if (getObj("con" + i) && getObj("m" + i)) {
                        getObj("con" + i).style.display = "none";
                        getObj("m" + i).className = ""
                    };
                if (getObj("con" + a) && getObj("m" + a)) {
                        if (getObj("ifrm" + a)) getObj("ifrm" + a).src = urlArr[a];
                        getObj("con" + a).style.display = "block";
                        getObj("m" + a).className = "at"
                    }
            }
        })
    }();

function statistic(a) {
        for (var i = 0, ci, p = [a.action + '?'], inps = a.getElementsByTagName('input'); ci = inps[i++];) {
            ci.type != 'submit' && (p.push(ci.name + '=' + ci.value))
        };
        (new Image).src = "http://clkstat.qihoo.com/stat.gif?_pdt=mph&_pg=2609&_bd=" + a.name + "&_u=" + encodeURIComponent(p.join('')) + "&_r=" + (+new Date) + "&_t=2";
        return true
    }; -
function () {
        var a = getCookie("360WEBINDEXCK"),
            url = location + '',
            param = url.split('?')[1];
        if (a && url.indexOf(a) == -1 && /^http:\/\/hao\.360\.cn\//i.test(a)) {
                location.href = a + (param ? (/\?/.test(a) ? '&' : '?') + param : '')
            }
    }();
if (getCookie("360WEBPW") == 1) getObj("widthS").href = widthCssPath;

function getCookie(a) {
        var b, reg = new RegExp("(^| )" + a + "=([^;]*)(;|$)");
        if (b = document.cookie.match(reg)) return unescape(b[2]);
        else return null
    };

function setCookie(a, b) {
        var c = arguments[2] ? arguments[2] : 365 * 24 * 60 * 60 * 1000;
        var d = new Date();
        d.setTime(d.getTime() + c);
        document.cookie = a + "=" + escape(b) + ";domain=hao.360.cn;path=/;expires=" + d.toGMTString()
    };

function visit(a) {
        a = a ? a : window.event;
        var s = (a.target) ? a.target : a.srcElement;
        if (s.tagName == "A" && s.parentNode.tagName == "LI" && s.href.indexOf("http://") == 0 && s.href.indexOf("http://" + location.host) != 0) setVisitCookie(s)
    };

function setVisitCookie(a) {
        cookieValue = a.innerHTML + "|" + a.href;
        if (!isVisited(cookieValue)) {
            visitedArr = get360VisitedWeb();
            expire = 1000 * 3600 * 24 * 30;
            if (visitedArr) {
                visited = '';
                var b = 20;
                var c = visitedArr.length >= b ? b - 1 : visitedArr.length;
                for (var i = 0; i < c; i++) {
                    if (visitedArr[i] != '') visited = visited == '' ? visitedArr[i] : visited + ";" + visitedArr[i]
                }
                setCookie(getVisitedCookieName(), cookieValue + ";" + visited, expire)
            } else {
                setCookie(getVisitedCookieName(), cookieValue, expire)
            }
        }
        return
    };
Array.prototype.in_array = function (e) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] && e == this[i]) return true
        }
        return false
    };

function getVisited() {
        return getCookie(getVisitedCookieName())
    };

function get360VisitedWeb() {
        visited = getVisited();
        if (!visited) return null;
        visitedArr = visited.split(";");
        if (visitedArr) return visitedArr;
        return null
    };

function isVisited(a) {
        visitedArr = get360VisitedWeb();
        if (visitedArr) return visitedArr.in_array(a);
        return false
    };

function getVisitedCookieName() {
        return "360WebUserVisited"
    }
document.onclick = visit;