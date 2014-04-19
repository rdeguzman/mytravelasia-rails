$(document).ready(function(){
	/* Navigation Dropdowns */
	$("#nav li li").hover(
		function () {
			$(this).parents("li").addClass("hover");
		},
		function () {
			$(this).parents("li").removeClass("hover");
		}
	);
	/* End Navigation Dropdowns */
});