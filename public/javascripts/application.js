// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var app = function(){
  // function offset(start) {
  //   for(i=start; i<10; i++) {
  //     console.log("example_2.offset - (start:"+start+") " + i);
  //     $("#hidden").append("<p>new element</p>");
  //   }
  // }
  var $rating_suggestion;
  var rating_suggestion_for = function(rating) {
    if(rating === 0)     { return "I don't want to rate this right now."; }
    else if(rating < 25) { return "I hated this"; }
    else if(rating < 50) { return "I didn't like this"; }
    else if(rating < 75) { return "I loved this"; }
    else if(rating < 90) { return "I really loved this!"; }
    else                 { return "You should see this right now!"; }
  };
  var menu_over = function() {
    $(this).addClass("over").find("a:not(ul li ul li a)").addClass("over");
  };
  var menu_out = function() {
    $(this).removeClass("over").find("a:not(ul li ul li a)").removeClass("over");
  };
  
  return {
    init: function() {
      this.build_menu_rollovers();
      $rating_suggestion = $("#rating_suggestion");
      this.button_mouseovers();
    },
    build_menu_rollovers: function() {
      $("#menu li").hover(menu_over, menu_out);
    },
    button_mouseovers:function() {
      $("#container .ui-button").hover(
      			function(){ $(this).addClass("ui-state-hover"); },
      			function(){ $(this).removeClass("ui-state-hover"); })
      		.mousedown(function(){ $(this).addClass("ui-state-active"); })
      		.mouseup(function(){ $(this).removeClass("ui-state-active"); });
    },
    rating_changing:function(event, ui){
      var val = (ui.value) > 0 ? ui.value : "no rating",
          suggestion = rating_suggestion_for(ui.value),
          $target = $(event.target),
          param = $target.attr("data-param"),
          position = $target.position();
      $(event.target).parent().find(".rating_value").html(val).addClass("pending");
      
      if($rating_suggestion.html() !== suggestion && $rating_suggestion.css("display") !== "show") {
        $rating_suggestion.html(suggestion).appendTo($(event.target).parent()).show();
      }
    },
    rating_change:function(event, ui){
      var val = (ui.value) > 0 ? ui.value : "no rating",
          $target = $(event.target),
          param = $target.attr("data-param"),
          url = "http://localhost:3000/movies/"+param+"/ratings";
      $target.parent().find(".rating_value").html(val).removeClass("pending");
      $rating_suggestion.hide();
      if(ui.value > 0) { $.post(url, { rating: ui.value }); }
      else { $.post(url+"/current", { _method:"delete" } ); }
    }
  };
}();

$(function() { app.init(); });