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