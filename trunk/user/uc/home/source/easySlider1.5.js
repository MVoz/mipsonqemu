/*
 * 	Easy Slider 1.5 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/post/4004/easy-slider-15-the-easiest-jquery-plugin-for-sliding
 *
 *	Copyright (c) 2009 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
/*
 *	markup example for jQuery("#slider").easySlider();
 *	
 * 	<div id="slider">
 *		<ul>
 *			<li><img src="images/01.jpg" alt="" /></li>
 *			<li><img src="images/02.jpg" alt="" /></li>
 *			<li><img src="images/03.jpg" alt="" /></li>
 *			<li><img src="images/04.jpg" alt="" /></li>
 *			<li><img src="images/05.jpg" alt="" /></li>
 *		</ul>
 *	</div>
 *
 */

(function(jQuery) {

	jQuery.fn.easySlider = function(options){
	  
		// default configuration properties
		var defaults = {			
			prevId: 		'prevBtn',
			prevText: 		'&laquo;',
			nextId: 		'nextBtn',	
			nextText: 		'&raquo;',
			controlsShow:	true,
			controlsBefore:	'',
			controlsAfter:	'',	
			controlsFade:	true,
			firstId: 		'firstBtn',
			firstText: 		'First',
			firstShow:		false,
			lastId: 		'lastBtn',	
			lastText: 		'Last',
			lastShow:		false,				
			vertical:		false,
			speed: 			2000,
			auto:			false,
			pause:			8000,
			continuous:		false
		}; 
		
		var options = jQuery.extend(defaults, options);  
				
		this.each(function() {  
			var obj = jQuery(this); 				
			var s = jQuery("li", obj).length;
			var w = jQuery("li", obj).width(); 
			var h = jQuery("li", obj).height(); 
			obj.width(w); 
			obj.height(h); 
			obj.css("overflow","hidden");
			var ts = s-1;
			var t = 0;
			jQuery("ul", obj).css('width',s*w);			
			if(!options.vertical) jQuery("li", obj).css('float','left');
			
			if(options.controlsShow){
				var html = options.controlsBefore;
				if(options.firstShow) html += '<span id="'+ options.firstId +'"><a href=\"javascript:void(0);\">'+ options.firstText +'</a></span>';
				html += ' <span id="'+ options.prevId +'"><a href=\"javascript:void(0);\">'+ options.prevText +'</a></span>';
				html += ' <span id="highlight_btns">';

				for(var i=0;i<s;i++)
				html += ' <span id="highlight_btn_'+ (i) +'"><a href=\"javascript:void(0);\">'+ (i+1) +'</a></span>';

				html += '</span>';
				html += ' <span id="'+ options.nextId +'"><a href=\"javascript:void(0);\">'+ options.nextText +'</a></span>';
				if(options.lastShow) html += ' <span id="'+ options.lastId +'"><a href=\"javascript:void(0);\">'+ options.lastText +'</a></span>';
				html += options.controlsAfter;						
				jQuery(obj).after(html);										
			};
			jQuery("#highlight_btns span").click(function(){ 
				animate(jQuery(this).attr("id"),true);
			});
			jQuery("#slider").hover(
			function(){ 
				clearTimeout(timeout);
			},
			function(){ 
				if(options.auto){
					clearTimeout(timeout);
					timeout = setTimeout(function(){
						animate("next",false);
					},options.pause);				
				}
			}
			);
			

			jQuery("a","#"+options.nextId).click(function(){		
				animate("next",true);
			});
			jQuery("a","#"+options.prevId).click(function(){		
				animate("prev",true);				
			});	
			jQuery("a","#"+options.firstId).click(function(){		
				animate("first",true);
			});				
			jQuery("a","#"+options.lastId).click(function(){		
				animate("last",true);				
			});		
			
			function animate(dir,clicked){
				var ot = t;				
				switch(dir){
					case "next":
						if(ot>=ts) 
								animate_dir=1;
						if(t<=0) 
								animate_dir=0;
						t = (ot>=ts) ? (options.continuous ? ((animate_dir==0)?0:ts-1 ): ts) : ((animate_dir==1)?(t-1):(t+1));						
						break; 
					case "prev":						
						t = (t<=0) ? (options.continuous ? ts : 0) : t-1;
						break; 
					case "first":
						t = 0;
						break; 
					case "last":
						t = ts;
						break; 
					default:
						t=parseInt(dir.substring(dir.length-1));
						break; 
				};	
				
				var diff = Math.abs(ot-t);
				var speed = diff*options.speed;	
				if(clicked)
					speed = diff*200;						
				if(!options.vertical) {
					p = (t*w*-1);
					jQuery("ul",obj).animate(
						{ marginLeft: p }, 
						speed
					);				
				} else {
					p = (t*h*-1);
					jQuery("ul",obj).animate(
						{ marginTop: p }, 
						speed
					);					
				};
				
				if(!options.continuous && options.controlsFade){					
					if(t==ts){
						jQuery("a","#"+options.nextId).hide();
						jQuery("a","#"+options.lastId).hide();
					} else {
						jQuery("a","#"+options.nextId).show();
						jQuery("a","#"+options.lastId).show();					
					};
					if(t==0){
						jQuery("a","#"+options.prevId).hide();
						jQuery("a","#"+options.firstId).hide();
					} else {
						jQuery("a","#"+options.prevId).show();
						jQuery("a","#"+options.firstId).show();
					};					
				};				
				
				if(clicked) clearTimeout(timeout);
				if(options.auto){;
					timeout = setTimeout(function(){
						animate("next",false);
					},diff*options.speed+options.pause);
				};
				
			};
			// init
			var timeout;
			var animate_dir=0;
			if(options.auto){;
				timeout = setTimeout(function(){
					animate("next",false);
				},options.pause);
			};		
		
			if(!options.continuous && options.controlsFade){					
				jQuery("a","#"+options.prevId).hide();
				jQuery("a","#"+options.firstId).hide();				
			};				
			
		});
	  
	};

})(jQuery);



