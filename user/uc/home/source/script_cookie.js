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