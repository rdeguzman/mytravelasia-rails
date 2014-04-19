$(document).ready(function(){

	/* Trips Viewer */
	$slideshow = {
		context: false,
		tabs: false,
		timeout: 3000,
		slideSpeed: 500,
		tabSpeed: 250,
		fx: 'fade',

		initFeaturedPois: function() {
			this.context = $('#featured-pois');
			this.tabs = $('ul.organizer-nav li.nav-button', this.context);
			this.tabs.remove();
			this.prepareSlideshow();
		},

		initMostViewedPois: function() {
			this.context = $('#most-viewed-pois');
			this.tabs = $('ul.organizer-nav li.nav-button', this.context);
			this.tabs.remove();
			this.prepareSlideshow();
		},

		prepareSlideshow: function() {
			$('div.organizer-container > ul', $slideshow.context).cycle({
				fx: $slideshow.fx,
				timeout: $slideshow.timeout,
				speed: $slideshow.slideSpeed,
				fastOnEvent: $slideshow.tabSpeed,
				pager: $('ul.organizer-nav', $slideshow.context),
				pagerAnchorBuilder: $slideshow.prepareTabs,
				before: $slideshow.activateTab,
				pauseOnPagerHover: true,
				pause: true
			});
		},

		prepareTabs: function(i, slide) {
			return $slideshow.tabs.eq(i);
		},

		activateTab: function(currentSlide, nextSlide) {
			var activeTab = $('a[href="#' + nextSlide.id + '"]', $slideshow.context);
		}
	};

	$(function() {
		$('body').addClass('js');

		$slideshow.initFeaturedPois();
		$slideshow.initMostViewedPois();
	});
	/* End Trips Viewer */

  	/* Trips Viewer Tabs */
	$(function() {
		$(".tab-content").hide();
		$("ul.tabs-nav li:first").addClass("active").show();
		$(".tab-content:first").show();

		$("ul.tabs-nav li").click(function() {

			$("ul.tabs-nav li").removeClass("active");
			$(this).addClass("active");
			$(".tab-content").hide();

			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	});
	/* End Trips Viewer Tabs */

});