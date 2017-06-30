function verticallyCenter(obj){
  var height = obj.height();
  obj.css("margin-top", String(Math.round(-height/2)) + "px");
}

// Close/open popups when corresponding link clicked
$(document).ready(function(){
  var wrapper = null;
  var popup = null;
  $(".popup_link").click(function(){
    switch ($(this).attr("id")){
      case "preferences_link":
        wrapper = $("#preferences_wrapper");
        popup = $("#preferences_popup");
        break;
      case "rename_tag_link":
        wrapper = $("#rename_wrapper");
        popup = $("#rename_popup")
        break;
    };
    wrapper.css("display", "flex");
    verticallyCenter(popup);
    return false;
  });
  $(".close_button").click(function(){
    // wrapper will be non-null because previous click function always runs first
    wrapper.css("display", "none");
    return false;
  });
});

// Handles centering of popups that open automatically (not clicked on)
$(document).ready(function(){
  $(".forced_popup").each(function(){
    verticallyCenter($(this));
  });
  $(".optional_popup").each(function(){
    verticallyCenter($(this));
  });
});

// Left and right button behaviour for pages in popups
$(document).ready(function(){
  $(".left_button").each(function(){
    var page_number = parseInt($(this).attr("id").slice(-1));
    var active = true
    if (page_number == 1){ // If on the first page, arrow does nothing
      $(this).css("cursor", "default");
      active = false
    };
    $(this).click(function(){ // On click, hide current page and show previous page
      if (active){
        $("div#page_" + String(page_number)).css("display", "none");
        $("div#page_" + String(page_number - 1)).css("display", "block");
      };
    });
  });
  $(".right_button").each(function(){
    var page_number = parseInt($(this).attr("id").slice(-1));
    var total_pages = $("div.popup_page").length;
    var active = true
    if (page_number == total_pages){ // If on the last page, arrow does nothing
      $(this).css("cursor", "default");
      active = false;
    };
    $(this).click(function(){ // On click, hide current page and show previous page
      if (active){
        $("div#page_" + String(page_number)).css("display", "none");
        $("div#page_" + String(page_number + 1)).css("display", "block");
      };
    });
  });
});
