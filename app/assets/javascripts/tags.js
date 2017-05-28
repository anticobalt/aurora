// Watch button to hide/show all previews
$(document).ready(function(){
  var shown = true;
  $("#toggle_all_previews_button").click(function(){
    if (shown){
      $(".preview").css("display", "none");
      shown = false;
    } else {
      $(".preview").css("display", "block");
      shown = true;
    };
  });
});

// Watch button to hide/show associated preview
$(document).ready(function(){
  $(".toggle_preview_button").click(function(){
    // Button and associated preview div share a class
    // namely, the id of the textfile model instance
    file_id = $(this).attr("class").split(" ")[1];
    preview = $("div." + file_id);
    if (preview.css("display") == "none"){
      preview.css("display", "block");
    } else {
      preview.css("display", "none");
    };
  });
});
