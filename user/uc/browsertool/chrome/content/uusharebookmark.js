var UushareTB = {
	strVersion : '1.0.4',

GetText:function() {
    var focusedWindow = document.commandDispatcher.focusedWindow;
    var winWrapper = new XPCNativeWrapper(focusedWindow, 'getSelection()');
    var searchStr = winWrapper.getSelection().toString();
    return searchStr;
},

AddToMyUushareBookmark:function() {

    window.open("http://192.168.115.2/uc/home/");
},

	getUBKCharPref: function(strPrefName) {
		this.prefManager = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
		try {
			return(this.prefManager.getCharPref("extensions.uusharebookmark." + strPrefName));		
		} catch(e) {
			return(false);	
		}
	},
	
		setUBKCharPref: function(strPrefName, strValue) {
		this.prefManager = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);			
		this.prefManager.setCharPref("extensions.uusharebookmark." + strPrefName, strValue);
	},
	
	onLoadEvent: function()
	{
		//first load
		var strPrefVersion = this.getUBKCharPref('version');
		
		if(strPrefVersion != this.strVersion) {
			
			var bolWongPostButtonExists = document.getElementById('UBK-Post');
			
			if(!bolWongPostButtonExists) {
				var objToolbox = document.getElementById("navigator-toolbox");	
				var strChild = '';
				var strSet = '';
				var objNavBar = false;
			
				if(objToolbox) {
					for (var i = 0; i < objToolbox.childNodes.length; ++i) {
						if(objToolbox.childNodes[i].id == "nav-bar" && objToolbox.childNodes[i].getAttribute("customizable") == "true") {
							objNavBar = objToolbox.childNodes[i];
							break;
						}
					}
				}
							
				if(objNavBar) {
					for (var i = 0; i < objNavBar.childNodes.length; i++) {
						if(objNavBar.childNodes[i].id == "urlbar-container") {
							if(!bolWongPostButtonExists) {
								strSet += "UBK-Post,"														
							}
						}
						strSet += objNavBar.childNodes[i].id + ",";
					}
					
					strSet = strSet.substring(0, strSet.length-1);
					objNavBar.currentSet = strSet;
					objNavBar.setAttribute("currentset", strSet);
					objNavBar.ownerDocument.persist(objNavBar.id, "currentset");
					BrowserToolboxCustomizeDone(true);
				} 
				
				strSet = strSet.substring(0, strSet.length-1);
				toolbar.currentSet = strSet;
				
				if(toolbar.setAttribute) {
					toolbar.setAttribute("currentset", strSet);
				}
				
				toolboxDocument.persist(toolbar.id, "currentset");
				BrowserToolboxCustomizeDone(true);		
			}
			
			this.setUBKCharPref('version', this.strVersion);
			
		}//end if first load
	}
}

window.addEventListener("load", function() 				{ UushareTB.onLoadEvent(); }, false);
