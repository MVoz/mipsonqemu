function initMenuEx() {
   jQuery('#menu ul').hide();
   jQuery('.showit').each(
  	function(){
  		 							  var obj=jQuery(this);
										  jQuery(this).show();
       								 obj.parents('ul').each(function(){ 
											jQuery(this).show();
       								});
  	}
  );
  jQuery('#menu li a').click(
    function(){
	  	  var obj=jQuery(this); 
	  	  if(1) {
       			jQuery('#menu ul:visible').each(function(){  
       								var id=jQuery(this).attr('id');
       								var isParent=0;
       								obj.parents('ul').each(function(){ 
       										if(id==jQuery(this).attr('id'))
       											isParent=1;
       								});
       							if(!isParent) jQuery(this).slideUp('normal'); 
       				});
        }
       var cE = jQuery(this).next();
				if((cE.is('ul')) && (cE.is(':visible'))) {
      	cE.slideUp('normal');
        }
       
        if((cE.is('ul')) && (!cE.is(':visible'))) {
   			jQuery('#menu ul:visible').each(function(){  
       								var id=jQuery(this).attr('id');
       								var isParent=0;
       								cE.parents('ul').each(function(){ 
       										if(id==jQuery(this).attr('id'))
       											isParent=1;
       								});
       							if(!isParent) jQuery(this).slideUp('normal'); 
       				});

				 cE.slideDown('normal');

       //  return false;
        }
		}
    ); 
 }

