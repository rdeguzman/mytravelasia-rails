$(document).ready(function(){
/* Fancybox Images */
	jQuery(function(){
		$("a.single_image").fancybox({
			'transitionIn'	: 'fades',
			'transitionOut'	: 'fade',
			'titlePosition'	: 'outside'
		});
		$("a.multi_images").fancybox({
			'transitionIn'	: 'fade',
			'transitionOut'	: 'fade',
			'titlePosition'	: 'outside'
		});
	});
	/* End Fancybox Images */


	/* Zoom Icon */
	$(function(){
		$(".zoom a").append("<span></span>");
		$(".zoom a").hover(function(){
			$(this).children("img").stop(true, true).animate({opacity:0.7},300);
			$(this).children("span").stop(true, true).fadeIn(300);
		},function(){
			$(this).children("img").stop(true, true).animate({opacity:1},250);
			$(this).children("span").stop(true, true).fadeOut(250);
		});
	});
	/* End Zoom Icon */
});