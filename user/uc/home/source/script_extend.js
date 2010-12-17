/*
function executeScript(html)
{
	if(html.indexOf('<script') == -1) return html;
    var reg = /<script[^>]*>([^\x00]+)$/i;
    var htmlBlock = html.split("<\/script>");
    for (var i in htmlBlock) 
    {
        var blocks;
		if (blocks = htmlBlock[i].match(reg)) 
        {
            var code = blocks[1].replace(/<!--/, '');
            try{eval(code)}
            catch (e) 
            {
            }
        }
    }
}
*/




/*
function strLen(str) {
	var charset = document.charset; 
	var len = 0;
	for(var i = 0; i < str.length; i++) {
		len += str.charCodeAt(i) < 0 || str.charCodeAt(i) > 255 ? (charset == "utf-8" ? 3 : 2) : 1;
	}
	return len;
}


function byteLength (sStr) {
	aMatch = sStr.match(/[^\x00-\x80]/g);
	return (sStr.length + (! aMatch ? 0 : aMatch.length));
}
function getStrbylen(str, len) {
	var num = 0;
	var strlen = 0;
	var newstr = "";
	var obj_value_arr = str.split("");
	for(var i = 0; i < obj_value_arr.length; i ++) {
		if(i < len && num + byteLength(obj_value_arr[i]) <= len) {
			num += byteLength(obj_value_arr[i]);
			strlen = i + 1;
		}
	}
	if(str.length > strlen) {
		newstr = str.substr(0, strlen);
	} else {
		newstr = str;
	}
	return newstr;
}
function killspace(str)
{
	while( str.charAt(0)==" " )
	{
		str=str.substr(1,str.length);
	}
	
	while( str.charAt(str.length-1)==" " )
	{
		str=str.substr(0,str.length-1);  
	}
	return str;
}
function getsiteview(classid){
	$.ajax({
			  type: "GET",
			  url:'space.php?do=navigation&inajax=1&classid='+classid,
			  success:function(data){
				if($('#bmcontent'))
					$('#bmcontent').html($(data).find('root').text());
				executeScript($(data).find('root').text());
			  }
	});
}
function getbmview(type) {
		//ajaxgetex('space.php?do=bookmark&op='+type, 'bmcontent','rdct','relatehtm');
		$.ajax({
			  type: "GET",
			  url:'space.php?do=bookmark&inajax=1&op='+type,
			  success:function(data){
				if($('#bmcontent'))
					$('#bmcontent').html($(data).find('root').text());
				executeScript($(data).find('root').text());
			  }
		});
}
function getbmtagview(tagid) {
		//ajaxgetex("space.php?do=linktag&tagid="+tagid, 'bmcontent','rdct','relatehtm');	    
		//ajaxget("space.php?do=linktag&tagid="+tagid, 'bmcontent');
		$.ajax({
			  type: "GET",
			  url:"space.php?do=linktag&inajax=1&tagid="+tagid,
			  success:function(data){
				if($('#bmcontent'))
					$('#bmcontent').html($(data).find('root').text());
				executeScript($(data).find('root').text());
			  }
		});
}
function getbrowserview(browserid) {
		//ajaxget("space.php?do=bookmark&op=browser&browserid="+browserid, 'bmcontent');
		$.ajax({
			  type: "GET",
			  url:"space.php?do=bookmark&inajax=1&op=browser&browserid="+browserid,
			  success:function(data){
				if($('#bmcontent'))
					$('#bmcontent').html($(data).find('root').text());
				executeScript($(data).find('root').text());
			  }
		});
}
function getlinkview(type) {
	ajaxget('space.php?do=link&op='+type, 'bmcontent');
}
*/

//cp_link.htm browser show
/*
function getdirtreefrombrowserid(id)
{
	$obj('browserid').value=id;
	$obj('menu').parentNode.removeChild($obj('menu'));
//	ajaxgetextend('space.php?do=browser&op=show&browserid='+id,initMenuEx,'browserdirtree'); 
	$.ajax({
		  type: "GET",
		  url:'space.php?do=browser&op=show&browserid='+id+'&inajax=1',
		  success:function(data){
			if($('#browserdirtree'))
				$('#browserdirtree').html($(data).find('root').text());
			executeScript($(data).find('root').text());
			initMenuEx();
		  }
	});
}
*/
