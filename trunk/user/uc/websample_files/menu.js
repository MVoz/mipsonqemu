
function initMenu() {
  $('#menu ul').hide();
 // $('#menu ul:first').show();
 //$('#menu8003').show();
 $('.showit').each(
  	function(){
  		 							  var obj=$(this);
										  $(this).show();
										 // $(this).children().show();
       								obj.parents('ul').each(function(){ 
											$(this).show();
       								});

  	}
  );


  $('#menu li a').click(
    function() {
	  var obj=$(this);
    
	  if(1) {
       			$('#menu ul:visible').each(function(){  
       								var id=$(this).attr('id');
       								var isParent=0;
       								obj.parents('ul').each(function(){ 
											//alert(id+'   '+$(this).attr('id'));
       										if(id==$(this).attr('id'))
       											isParent=1;
       								});
       							if(!isParent) $(this).slideUp('normal'); 
       				});

				// checkElement.slideDown('normal');

				// return false;
        }
	  var checkElement = $(this).next();
      if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
      	checkElement.slideUp('normal');
      //  return false;
        }
     
      if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
       			$('#menu ul:visible').each(function(){  
       								var id=$(this).attr('id');
       								var isParent=0;
       								checkElement.parents('ul').each(function(){ 
       										if(id==$(this).attr('id'))
       											isParent=1;
       								});
       							if(!isParent) $(this).slideUp('normal'); 
       				});

				 checkElement.slideDown('normal');

       //  return false;
        }
      }
    );
  }
$(document).ready(function() {initMenu(); });