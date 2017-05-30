// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// CoffeeScript removed because stackoverflow.com/questions/28312460/object-doesnt-support-this-property-or-method-rails-windows-64bit
//= require_tree .

// Hide flash.notice when clicked on
$(document).ready(function(){
  $("div#alert").click(function(){
   $(this).css("display", "none");
 });
});
