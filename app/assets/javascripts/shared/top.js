// Keep navigation bar on top of page if scrolled past
$(document).ready(function(){
  // Reaching the bottom of the page causes the navigation bar to only be half showing,
  // => causeing the scroll to glitch out, and the bottom to be unreachable.
  // Nav bar is half-showing only when the center or parent divs are smaller
  // => then the window itself.
  var main_div_too_small = false;
  // (Not-so) fun fact: null is both greater and less than every number.
  var parent_small = $("#parent").height() != null && $("#parent").height() < $(window).height()
  var center_small = $("#center").height() != null && $("#center").height() < $(window).height()
  if (parent_small || center_small){
    main_div_too_small = true;
  } else {
    main_div_too_small = false;
  };
  $(window).scroll(function(){
    // Toggle "fixed" class based on whether the anchor is passed or not
    // Check the anchor to stop the actual navbar from flashing during checks
    // Stolen from stackoverflow.com/questions/2907367/have-a-div-cling-to-top-of-screen-if-scrolled-down-past-it
     $("div#navigation").toggleClass("fixed-topcenter", !main_div_too_small &&
     ($(window).scrollTop() > $("div#navigation_anchor").offset().top));
  });
});
