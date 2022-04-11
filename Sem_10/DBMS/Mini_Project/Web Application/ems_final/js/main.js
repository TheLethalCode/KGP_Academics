(function ($) {
 "use strict";

/*----------------------------
 jQuery MeanMenu
------------------------------ */
	jQuery('nav#dropdown').meanmenu({
		onePage:true
	});	
	
	
/*----------------------------
 wow js active
------------------------------ */
 new WOW().init();
 
/*----------------------------
One Page nav
------------------------------ */
var top_offset = $('.logo-menu-area').height() - -70;  // get height of fixed navbar
$('#nav').onePageNav({
 scrollOffset: top_offset,
  scrollSpeed: 750,
  easing: 'swing',
  currentClass: 'current',
});

/*----------------------------
 owl active
------------------------------ */  
// total speaker
  $(".total-speaker").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:true,	  
      items : 4,
	  /* transitionStyle : "fade", */    /* [This code for animation ] */
	  navigationText:["<i class='zmdi zmdi-chevron-left'></i>","<i class='zmdi zmdi-chevron-right'></i>"],
      itemsDesktop : [1199,3],
	  itemsDesktopSmall : [980,2],
	  itemsTablet: [768,2],
	  itemsMobile : [765,1],
  });

  // total news
  $(".total-news").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:true,	  
      items : 3,
	  /* transitionStyle : "fade", */    /* [This code for animation ] */
	  navigationText:["<i class='zmdi zmdi-chevron-left'></i>","<i class='zmdi zmdi-chevron-right'></i>"],
      itemsDesktop : [1199,3],
	  itemsDesktopSmall : [980,2],
	  itemsTablet: [768,2],
	  itemsMobile : [765,1],
  });
  // instgram Feed
  $(".total-feed").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:true,	  
      items : 4,
	  /* transitionStyle : "fade", */    /* [This code for animation ] */
	  navigationText:["<i class='zmdi zmdi-chevron-left'></i>","<i class='zmdi zmdi-chevron-right'></i>"],
      itemsDesktop : [1199,4],
	  itemsDesktopSmall : [980,4],
	  itemsTablet: [768,2],
	  itemsMobile : [479,1],
  });
  
// what happen
  $(".total-happen").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:false,	  
      items : 3,
      itemsDesktop : [1199,3],
	  itemsDesktopSmall : [980,2],
	  itemsTablet: [768,2],
	  itemsMobile : [765,1],
  });  
// total testimonial
  $(".total-testimonial").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:true,
	  navigation:false,	  
      items : 1,
      itemsDesktop : [1199,1],
	  itemsDesktopSmall : [980,1],
	  itemsTablet: [768,1],
	  itemsMobile : [479,1],
  }); 
  $(".total-testi-02").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:true,
	  navigation:false,	  
      items : 2,
      itemsDesktop : [1199,2],
	  itemsDesktopSmall : [980,2],
	  itemsTablet: [768,2],
	  itemsMobile : [479,1],
  }); 
// total Blog
  $(".total-blog").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:false,	  
      items : 2,
      itemsDesktop : [1199,2],
	  itemsDesktopSmall : [980,2],
	  itemsTablet: [768,2],
	  itemsMobile : [479,1],
  });
// total related post
  $(".total-related-post").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:false,	  
      items : 2,
      itemsDesktop : [1199,2],
	  itemsDesktopSmall : [980,1],
	  itemsTablet: [768,1],
	  itemsMobile : [479,1],
  });  
// brand slider
  $(".total-brand").owlCarousel({
      autoPlay: false, 
	  slideSpeed:2000,
	  pagination:false,
	  navigation:false,	 
	  addClassActive : true,
      items : 6,
      itemsDesktop : [1199,6],
	  itemsDesktopSmall : [980,5],
	  itemsTablet: [768,3],
	  itemsMobile : [479,2],
  });
    /*----------------------------
     counterUp
    ------------------------------ */
    $('.counter2').counterUp({
        delay: 10,
        time: 1000
    });
	// datepicker
	$('.date').datepicker({
		'format': 'm/d/yyyy',
		'autoclose': true
	});	
	   
/*--------------------------
 scrollUp
---------------------------- */	
	$.scrollUp({
        scrollText: "<i class='zmdi zmdi-arrow-merge'></i>",
        easingType: 'linear',
        scrollSpeed: 900,
        animation: 'fade'
    }); 
/*----------------------------
 sticky menu 
------------------------------ */
      var s = $("#sticker");
      var pos = s.position();
      $(window).scroll(function () {
          var windowpos = $(window).scrollTop();
          if (windowpos >= pos.top) {
              s.addClass("stick");
          } else {
              s.removeClass("stick");
          }
      });
/*--------------------------
 menu nav
---------------------------- */	
$('.shedule-head').on('click', function(){
    $('.panel').removeClass('active');
    $(this).parent('.panel').addClass('active');
});
/*--------------------------
Yotube Bg
---------------------------- */	    
   $(".youtube-bg").YTPlayer({
	videoURL:"Bi2qPmlrgko",
	containment:'.youtube-bg',
	autoPlay:true,
	loop:true,
}); 
/*--------------------------
scroll down
---------------------------- */	   
$(".see-demo-btn").on('click', function (e) {
    e.preventDefault();
    $('html,body').animate({
        scrollTop: $("#about-event").offset().top -100
    }, 'slow');
});

})(jQuery); 