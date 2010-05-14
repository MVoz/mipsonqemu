function getbmview(type) {
		ajaxgetex('space.php?do=bookmark&op='+type, 'bmcontent','relatedcontent','relatehtm');	    
}

function getlinkview(type) {
	ajaxget('space.php?do=link&op='+type, 'bmcontent');
}

function getbmfromid(groupid,browserid,name) {
	if(groupid==0)
	{
		jQuery('#menuroot').addClass('green');
		jQuery('#menu li a').removeClass('green');
		jQuery('#menu ul').hide();
	}
	ajaxgetex('space.php?do=bookmark&op=browser&groupid='+groupid+'&browserid='+browserid, 'bmcontent','relatedcontent','relatehtm');
	
	$('groupdo').innerHTML='<span class="addcomment"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="bmdir_add_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_new\',this.id,1)">增加</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=edit" id="bmdir_edit_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_new\',this.id,1)">修改</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=delete" id="bmdir_delete_'+groupid+'" onclick="ajaxmenu(event,this.id,1)">删除</a></span>';
	$('groupname').innerHTML=name+'&raquo;';
}
//cp_link.htm browser show

function getdirtreefrombrowserid(id)
{
	$('browserid').value=id;
	$('menu').parentNode.removeChild($('menu'));
	ajaxgetextend('space.php?do=browser&op=show&browserid='+id,initMenuEx,'browserdirtree'); 
}

function setbookmarkgroupid(id)
{
	if(id==0)
	{
		jQuery('#menuroot').addClass('green');
		jQuery('#menu li a').removeClass('green');
		jQuery('#menu ul').hide();
	}
	$('browsergroupid').value=id;
}

function ajaxresponse(objname, data) {
	var x = new Ajax('XML', objname);
	x.get('cp.php?ac=bookmark&' + data, function(s){
	});
}

function updatevisitstat(id) {
	ajaxresponse('visitstat', 'op=updatevisitstat&bmid=' + id);
}
function updatelinkup(id) {
	ajaxupdate('link','up_num', 'op=updatelinkupnum&linkid=' + id);
}
function updatelinkdown(id) {
	ajaxupdate('link','down_num', 'op=updatelinkdownnum&linkid=' + id);
}
function updatelinkview(id) {
	ajaxupdate('link','view_num', 'op=updatelinkviewnum&linkid=' + id);
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
	ajaxget('cp.php?ac=link&op=relate&linkid='+id, 'relatedsitecontent');    
}

var lastSecCode='';

function checkSeccode() {
		var seccodeVerify = $('seccode').value;
		if(seccodeVerify == lastSecCode) {
			return;
		} else {
			lastSecCode = seccodeVerify;
		}
		ajaxresponse('checkseccode', 'op=checkseccode&seccode=' + (is_ie && document.charset == 'utf-8' ? encodeURIComponent(seccodeVerify) : seccodeVerify));
}
function ajaxupdate(ac,objname, data) {
		var x = new Ajax('XML', objname);
		x.get('cp.php?ac='+ac+'&' + data, function(s){
			var obj = $(objname);
			if(obj){
				obj.style.display = '';
				obj.innerHTML =s;
			}
		});
}
function ajaxresponse(objname, data) {
		var x = new Ajax('XML', objname);
		x.get('cp.php?ac=link&' + data, function(s){
			var obj = $(objname);
			s = trim(s);
			if(s.indexOf('succeed') > -1) {
				obj.style.display = '';
				obj.innerHTML = '<img src="image/check_right.gif" width="13" height="13">';
				obj.className = "warning";
				//$('btnsubmit').disabled=false;
				//$('btnsubmit').className="submit";
			} else {
				warning(obj, s);
				//$('btnsubmit').disabled=true;
				//$('btnsubmit').className="submit_disabled";
			}
		});
}

function warning(obj, msg) {
		if((ton = obj.id.substr(5, obj.id.length)) != 'password2') {
			$(ton).select();
		}
		obj.style.display = '';
		obj.innerHTML = '<img src="image/check_error.gif" width="13" height="13"> &nbsp; ' + msg;
		obj.className = "warning";
}
