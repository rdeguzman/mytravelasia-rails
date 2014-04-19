$(document).ready(function(){
	/* News Toggler */
	$(function(){
		$(".collapsible-content").hide();
		$('.news-trigger').toggle(
			function() {
				$(this).toggleClass("opened").parent().next().slideDown();
				$(this).html('Collapse <img src="/images/button-arrow-up.png" alt="" class="collapse-arrow-up">');
			},
			function() {
				$(this).toggleClass("opened").parent().next().slideUp();
				$(this).html('Read More...');
			}
		);
	});
	/* End News Toggler */

	/* Collapse Toggler: Map and Destinations */
	jQuery(function(){
		$('.collapse-trigger').toggle(
			function() {
				$(this).next().next().slideUp().parent().toggleClass("closed");
				$(this).html('<img src="/images/collapse-button-down.png" alt="" />');
			},
			function() {
				$(this).next().next().slideDown().parent().toggleClass("closed");
				$(this).html('<img src="/images/collapse-button-up.png" alt="" />');
			}
		);
	});
	/* End Archive Toggler */
});