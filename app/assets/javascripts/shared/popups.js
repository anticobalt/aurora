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
  $(".close_button, .submit_button").click(function(){
    // wrapper will be non-null because previous function always run first
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
