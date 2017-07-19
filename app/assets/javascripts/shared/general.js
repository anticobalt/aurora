// Hide flash.notice when clicked on
$(document).ready(function(){
  $("div#alert").click(function(){
   $(this).css("display", "none");
 });
});

// Scroll to top of page when "To Top" button clicked.
$(document).ready(function(){
  $("#link_to_top").click(function(){
    /*
    HTML selector for animate makes scroll work in Firefox.
    Animate slightly faster than default speed.
    */
    $("body, html").animate({scrollTop: 0}, 300);
    return false; // prevents reload on click
  });
});

// Show/hide hidden elements when parent element clicked
$(document).ready(function(){
  $(".hidden_components").click(function(){
    $(this).find(".hidden").each(function(){
      if ($(this).css("display") == "none"){
        $(this).css("display", "block");
      } else if ($(this).css("display") == "block"){
        $(this).css("display", "none")
      };
    });
  });
});
