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
		 // obj.css('font-weight','bold');
		 jQuery('#menu li a').removeClass('green');
		 jQuery('#menuroot').removeClass('green');
		  obj.addClass('green');
	  	  if(1) {
       				jQuery('#menu ul:visible').each(function(){  
       								var id=jQuery(this).attr('id');
       								var isParent=0;
       								obj.parents('ul').each(function(){										
       									if(id==jQuery(this).attr('id'))
										{
												  isParent=1;		 
												
										}
										// jQuery(this).prev().removeClass('green');
												
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
       							if(!isParent) {
									jQuery(this).slideUp('normal'); 
							
								}
       				});

				 cE.slideDown('normal');

       //  return false;
        }
		}
    ); 
 }

(function(jQuery){
jQuery.fn.extend({
Scroll:function(opt,callback){
//������ʼ��
if(!opt) var opt={};
	var _this=this.eq(0).find("ul:first");
	var lineH=_this.find("li:first").height(),//��ȡ�и�
	line=opt.line?parseInt(opt.line,10):parseInt(this.height()/lineH,10), //ÿ�ι�����������Ĭ��Ϊһ�������������߶�
	speed=opt.speed?parseInt(opt.speed,10):500, //���ٶȣ���ֵԽ���ٶ�Խ�������룩
	timer=opt.timer?parseInt(opt.timer,10):3000; //������ʱ���������룩
if(line==0) line=1;
var upHeight=0-line*lineH;
//��������
scrollUp=function(){
_this.animate({
	marginTop:upHeight
	},speed,function(){
for(i=1;i<=line;i++){
	_this.find("li:first").appendTo(_this);
}
	_this.css({marginTop:0});
});
}
//����¼���
_this.hover(function(){
clearInterval(timerID);
},function(){
	timerID=setInterval("scrollUp()",timer);
}).mouseout();
}       
})
})(jQuery);