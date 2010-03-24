/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: script_manage.js 11845 2009-03-26 08:00:50Z liguode $
*/


function digg_submit(obj)
{
	mainForm = obj.form;
	forms = $('attachbody').getElementsByTagName("FORM");
	albumid = $('uploadalbum').value;
	upload();
}
function validate(obj) {
    var subject = $('subject');
    if (subject) {
    	var slen = strlen(subject.value);
        if (slen < 1 || slen > 80) {
            alert("标题长度(1~80字符)不符合要求");
            subject.focus();
            return false;
        }
    }
    var address = $('address');
    if (address) {
        var   regUrl   =   /([http|https]\:\/\/)([\w.]+)(\/[\w-   \.\/\?%&=]*)?/gi;
		var   result   =   address.value.match(regUrl);
		if(result == null) { 
				alert("请输入正确的网址");
				address.focus();
				return false;
        }
    }
	var tag = $('tag');
    if (tag) {
    	var slen = strlen(tag.value);
        if (slen < 1 ) {
            alert("请输入一些与这篇文章相关的标签");
            tag.focus();
            return false;
        }
    }
	var description = $('description');
    if (description) {
    	var slen = strlen(description.value);
        if (slen < 10 || slen > 200 ) {
            alert("请对此文章做一些简要的描述(10~200字符)");
            description.focus();
            return false;
        }
    }
    if($('seccode')) {
		var code = $('seccode').value;
		var x = new Ajax();
		x.get('cp.php?ac=common&op=seccode&code=' + code, function(s){
			s = trim(s);
			if(s.indexOf('succeed') == -1) {
				alert(s);
				$('seccode').focus();
           		return false;
			} else {
				digg_submit(obj);
				return true;
			}
		});
    } else {
    	digg_submit(obj);
    	return true;
    }
}

function edit_album_show(id) {
	var obj = $('uchome-edit-'+id);
	if(obj.style.display == '') {
		obj.style.display = 'none';
	} else {
		obj.style.display = '';
	}
}
