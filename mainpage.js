// Mobile Navigation
$('.mobile-toggle').click(function() {
    if ($('.main_nav').hasClass('open-nav')) {
        $('.main_nav').removeClass('open-nav');
    } else {
        $('.main_nav').addClass('open-nav');
    }
});

$('.main_nav li a').click(function() {
    if ($('.main_nav').hasClass('open-nav')) {
        $('.navigation').removeClass('open-nav');
        $('.main_nav').removeClass('open-nav');
    }
});



// Smooth Scrolling Using JQuery

jQuery(document).ready(function($) {

   $('.smoothscroll').on('click',function (e) {
	    e.preventDefault();

	    var target = this.hash,
	    $target = $(target);

	    $('html, body').stop().animate({
	        'scrollTop': $target.offset().top
	    }, 800, 'swing', function () {
	        window.location.hash = target;
	    });
	});

});

TweenMax.from(".device", 0.8, {y: 50, opacity: 0, ease:Back.easeOut, delay: 1});
TweenMax.from(".header", 0.8, {opacity: 0, x: 30, delay: 0.2});
TweenMax.from(".subheader", 1, {opacity: 0, x: -30, delay: 0.6});
TweenMax.from(".paragraph", 1, {opacity: 0, delay: 1, y: 20});
TweenMax.from(".btn", 0.5, {y: 10, opacity: 0, delay: 1.6});  