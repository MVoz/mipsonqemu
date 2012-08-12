function getHtml(path){OptionsDlg.getHtml(path);}
function reject(){OptionsDlg.reject();}
function tr(a){document.write(OptionsDlg.tr(a));}
function gohref(url){OptionsDlg.gohref(url);}
function $obj(a){return document.getElementById(a);}

$(function(){   
	imgLoader = new Image();// preload image
	imgLoader.src = "../image/ajax-loader.gif";
});
function tb_init(domChunk){
	$(domChunk).click(function(){
	var t = this.title || this.name || null;
	var a = this.href;
	var g = this.rel || false;
	params=tb_parseQuery(g);
	tb_show(t,a,params);
	this.blur();
	return false;
	});
}

function tb_show(caption, url, params) {//function called when the user clicks on a thickbox link
	try {
		if(document.getElementById("TB_overlay") === null){
				$("body").append("<div id='TB_overlay'></div><div id='TB_window'></div>");
				$("#TB_overlay").click(tb_remove);
		}
		url = url.substring(4,url.length);
		if(tb_detectMacXFF()){
			$("#TB_overlay").addClass("TB_overlayMacFFBGHack");//use png overlay so hide flash
		}else{
			$("#TB_overlay").addClass("TB_overlayBG");//use background and opacity
		}
		if(caption===null){caption="";}
		$("body").append("<div id='TB_load'><img src='"+imgLoader.src+"' /></div>");//add loader to the page
		$('#TB_load').show();//show loader
		TB_WIDTH = parseInt(params['width']);
		TB_HEIGHT = parseInt(params['height']);
		if(1){
			var queryString = url.replace(/^[^\?]+\??/,'');
			var params = tb_parseQuery( queryString );
			TB_WIDTH=(TB_WIDTH>0)?(TB_WIDTH+30):540;
			TB_HEIGHT=(TB_HEIGHT>0)?(TB_HEIGHT+40):300;

			ajaxContentW = TB_WIDTH - 30;
			ajaxContentH = TB_HEIGHT - 45;
			if(1){// either iframe or ajax window		
						$("#TB_iframeContent").remove();				
						$("#TB_window").append("<div id='TB_iframeContent' name='TB_iframeContent"+Math.round(Math.random()*1000)+"' style='width:"+(ajaxContentW + 29)+"px;height:"+(ajaxContentH + 17)+"px;' > </div>");
						$("#TB_iframeContent").html($("#"+url).html());
						tb_showIframe();
			}
			$("#TB_closeWindowButton").click(tb_remove);

			tb_position();
			$("#TB_load").remove();
			$("#TB_window").css({display:"block"});			
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
 $(function(){
        $("input, textarea, select, button").uniform();
		//nav
		$("#nav").append('<li><a class="demos" href="index.html">通&nbsp;&nbsp;&nbsp;用</a></li>');
		$("#nav").append('<li><a class="howto" href="net.html">网&nbsp;&nbsp;&nbsp;络</a></li>');
        $("#nav").append('<li><a class="opts" href="custom.html">目录&amp;命令</a></li>');
        $("#nav").append('<li class="fl_r"><a class="buy">&nbsp;</a></li>');
		//apply
		$("#apply > ul").append('<li><a href="#">取消</a></li>');
		$("#apply > ul").append('<li><a href="#">确定</a></li>');		
		//footer
		$("#footer ul").append('<li>&copy; 2012 - <a href="http://codecanyon.net/user/360north">360north</a> &nbsp;/&nbsp; <a href="http://codecanyon.net/user/360north/follow">Follow on Envato</a></li>');

 });