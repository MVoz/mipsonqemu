function getbmview(type) {
		ajaxgetex('space.php?do=bookmark&op='+type, 'bmcontent','relatedcontent','relatehtm');	    
}

function getlinkview(type) {
	ajaxget('space.php?do=link&op='+type, 'bmcontent');
}

function getbmfromid(groupid,browserid,name,isroot) {
	if(groupid==0)
	{
		jQuery('#menuroot').addClass('green');
		jQuery('#menu li a').removeClass('green');
		jQuery('#menu ul').hide();
	}
	ajaxgetex('space.php?do=bookmark&op=browser&groupid='+groupid+'&browserid='+browserid, 'bmcontent','relatedcontent','relatehtm');
	
	if(groupid!=0&&isroot==0)
	{
		$('groupdo').innerHTML='<span class="addcomment"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="bmdir_add_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_add_'+groupid+'\',this.id,1)">增加</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=edit" id="bmdir_edit_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_edit_'+groupid+'\',this.id,1)">修改</a></span><span class="addtrackback"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=delete" id="bmdir_delete_'+groupid+'" onclick="ajaxmenu(event,this.id,1)">删除</a></span>';
	}
	else{
		$('groupdo').innerHTML='<span class="addcomment"><a href="cp.php?ac=bmdir&bmdirid='+groupid+'&browserid='+browserid+'&op=add" id="bmdir_add_'+groupid+'" onclick="ajaxmenuEx(event,\'img_seccode_add_'+groupid+'\',this.id,1)">增加</a></span>';
	}
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

function updatevisitstat(id) {
	ajaxresponse('visitstat', 'op=updatevisitstat&bmid=' + id);
}
var updatelinkupclick=0;
function updatelinkup(id) {
	if(!updatelinkupclick)
	{
		ajaxupdate('link','up_num', 'op=updatelinkupnum&linkid=' + id);
		updatelinkupclick=1;
	}
}
var updatelinkupdown=0;
function updatelinkdown(id) {
	if(!updatelinkupdown)
	{
		ajaxupdate('link','down_num', 'op=updatelinkdownnum&linkid=' + id);
		updatelinkupdown=1;
	}
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

function checkSeccode() {
		var  seccodeVerify= $('seccode').value;
		
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
			$(ton).select();
		}
	*/
		obj.style.display = '';
		obj.innerHTML = '<img src="image/check_error.gif" width="13" height="13"> &nbsp; ' + msg;
		obj.className = "warning";
}
function clearwarning(obj) {
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
/*
function checkemail(email)//M12 
{
	if(typeof email == "undefined")return false;
	var pattern = /^(([a-zA-Z0-9_.\-])+@([a-zA-Z0-9_\-])+(\.[a-zA-Z0-9_\-]+)+){0,1}$/;  
	var email_array = email.split("\r\n");
	for (i = 0; i < email_array.length; i++)
	{
		if (!killspace(email_array[i]))
			continue;
		if(!pattern.test(killspace(email_array[i])))
			return false;
	}
	return true;
}
*/
function checkemail(emailStr) {
               if (emailStr.length == 0) {
                   return true;
               }
               var emailPat=/^(.+)@(.+)$/;
               var specialChars="\\(\\)<>@,;:\\\\\\\"\\.\\[\\]";
               var validChars="\[^\\s" + specialChars + "\]";
               var quotedUser="(\"[^\"]*\")";
               var ipDomainPat=/^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/;
               var atom=validChars + '+';
               var word="(" + atom + "|" + quotedUser + ")";
               var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
               var domainPat=new RegExp("^" + atom + "(\\." + atom + ")*$");
               var matchArray=emailStr.match(emailPat);
               if (matchArray == null) {
                   return false;
               }
               var user=matchArray[1];
               var domain=matchArray[2];
               if (user.match(userPat) == null) {
                   return false;
               }
               var IPArray = domain.match(ipDomainPat);
               if (IPArray != null) {
                   for (var i = 1; i <= 4; i++) {
                      if (IPArray[i] > 255) {
                         return false;
                      }
                   }
                   return true;
               }
               var domainArray=domain.match(domainPat);
               if (domainArray == null) {
                   return false;
               }
               var atomPat=new RegExp(atom,"g");
               var domArr=domain.match(atomPat);
               var len=domArr.length;
               if ((domArr[domArr.length-1].length < 2) ||
                   (domArr[domArr.length-1].length > 3)) {
                   return false;
               }
               if (len < 2) {
                   return false;
               }
               return true;
} 

