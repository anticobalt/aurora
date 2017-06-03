// Hide flash.notice when clicked on
$(document).ready(function(){
  $("div#alert").click(function(){
   $(this).css("display", "none");
 });
});

// Scroll to top of page when "To Top" button clicked
$(document).ready(function(){
  $("#link_to_top").click(function(){
    // Add html selector to make scroll work in Firefox
    $("body, html").animate({scrollTop: 0}, 300); // slightly faster than default speed
    return false; // prevent reload on click
  });
});
