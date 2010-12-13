function getbmview(type) {
		ajaxgetex('space.php?do=bookmark&op='+type, 'bmcontent','rdct','relatehtm');	    
}
function getbmtagview(tagid) {
		//ajaxgetex("space.php?do=linktag&tagid="+tagid, 'bmcontent','rdct','relatehtm');	    
		ajaxget("space.php?do=linktag&tagid="+tagid, 'bmcontent');
}
function getbrowserview(browserid) {
		ajaxget("space.php?do=bookmark&op=browser&browserid="+browserid, 'bmcontent');
}
function getlinkview(type) {
	ajaxget('space.php?do=link&op='+type, 'bmcontent');
}

function getbmfromid(groupid,browserid,name,isroot) {
	if(groupid==0)
	{
		$('#menuroot').addClass('green');
		$('#menu li a').removeClass('green');
		$('#menu ul').hide();
	}
	ajaxgetex('space.php?do=bookmark&op=browser&groupid='+groupid+'&browserid='+browserid, 'bmcontent','rdct','relatehtm');
	
	if(groupid!=0&&isroot==0)
	{
		$obj('groupdo').innerHTML='<span class="addcomment"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="bmdir_add_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_add_'+groupid+'\',this.id,1)">增加</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=edit" id="bmdir_edit_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_edit_'+groupid+'\',this.id,1)">修改</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=delete" id="bmdir_delete_'+groupid+'" onclick="ajaxmenu(event,this.id,1)">删除</a></span>';
	}
	else{
		$obj('groupdo').innerHTML='<span class="addcomment"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="bmdir_add_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_add_'+groupid+'\',this.id,1)">增加</a></span>';
	}
	$obj('groupname').innerHTML=name+'&raquo;';
}
//cp_link.htm browser show

function getdirtreefrombrowserid(id)
{
	$obj('browserid').value=id;
	$obj('menu').parentNode.removeChild($obj('menu'));
	ajaxgetextend('space.php?do=browser&op=show&browserid='+id,initMenuEx,'browserdirtree'); 
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
				if($('#'+o))
					$('#'+o).html($(data).find('root').text());				
			  }
		});
		this.blur();
		return false;
}


function updatediggup(id) {
	ajaxupdate('digg','digg_up_num_id_'+id, 'op=updatediggupnum&diggid=' + id);
}
function updatediggdown(id) {
	ajaxupdate('digg','digg_down_num_id_'+id, 'op=updatediggdownnum&diggid=' + id);
}
function updatediggview(id) {
	ajaxupdate('digg','digg_view_num_id_'+id, 'op=updatediggviewnum&diggid=' + id);
}
function getrelatedlinkfromid(id) {
	ajaxget('cp.php?ac=link&op=relate&linkid='+id, 'rdsect');    
}

var lastSecCode='';
function checkSeccode() {
		var  seccodeVerify= $obj('seccode').value;
		
		if(seccodeVerify == lastSecCode) {
			return;
		} else {
			lastSecCode = seccodeVerify;
		}
		ajaxresponse('checkseccode', 'op=checkseccode&seccode=' + (is_ie && document.charset == 'utf-8' ? encodeURIComponent(seccodeVerify) : seccodeVerify));
}

function warning(obj, msg) {
	/*
		if((ton = obj.id.substr(5, obj.id.length)) != 'password2') {
			$obj(ton).select();
		}
	*/
		obj.style.display = '';
		obj.innerHTML = '<img src="image/check_error.gif" width="13" height="13"> &nbsp; ' + msg;
		obj.className = "warning";
}
function clearwarning(obj){
		obj.style.display = 'none';
		obj.innerHTML = '';		
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
function byteLength (sStr) {
	aMatch = sStr.match(/[^\x00-\x80]/g);
	return (sStr.length + (! aMatch ? 0 : aMatch.length));
}
function strLen(str) {
	var charset = document.charset; 
	var len = 0;
	for(var i = 0; i < str.length; i++) {
		len += str.charCodeAt(i) < 0 || str.charCodeAt(i) > 255 ? (charset == "utf-8" ? 3 : 2) : 1;
	}
	return len;
}

