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
//参数初始化
if(!opt) var opt={};
	var _this=this.eq(0).find("ul:first");
	var lineH=_this.find("li:first").height(),//获取行高
	line=opt.line?parseInt(opt.line,10):parseInt(this.height()/lineH,10), //每次滚动的行数，默认为一屏，即父容器高度
	speed=opt.speed?parseInt(opt.speed,10):500, //卷动速度，数值越大，速度越慢（毫秒）
	timer=opt.timer?parseInt(opt.timer,10):3000; //滚动的时间间隔（毫秒）
if(line==0) line=1;
var upHeight=0-line*lineH;
//滚动函数
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
//鼠标事件绑定
_this.hover(function(){
clearInterval(timerID);
},function(){
	timerID=setInterval("scrollUp()",timer);
}).mouseout();
}       
})
})(jQuery);