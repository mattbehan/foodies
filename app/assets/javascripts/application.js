// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

// Jquery
$(function() {
  // Pagination AJAX
  $("#restaurants").on("click",".pagination a", function(){
    $(".pagination").html("Page is loading...");
    $.get(this.href, null, null, "script")
    return false
  })
  //SVG Redirect
  $("path").on("click", function(){
    var neighborhood = $(this).attr("id")
    console.log(
      $(this).attr("id")
    );
    window.location.href = '/search'+"?search="+neighborhood;
  })

  $(".bad-comment-warning a").on("click", function(){
    $(this).parent().toggle();
    $(this).parent().prev().show();
  })

  $(".comment-toggle").on("click", function(){
    $(this).hide();
    $(this).next().toggle();
  })

  $(".new-comment-form-toggle").on("click", function(){
    $(this).hide();
    $(this).next().toggle();
  })

  $(".specialties-container").on("click",".specialties-toggle", function(event){
    event.preventDefault();
    $(this).hide();
    $(".rest-of-specialties").show();
    $(".new-specialties-form").show();
  })
  // SearchBar geolocation

  $("#search-form").on("submit", function(event){
    event.preventDefault();
    $('#search').addClass('loadinggif');

    var latitude, longitude;
    navigator.geolocation.getCurrentPosition(success, fail,
    {
      enableHighAccuracy: true,
      timeout: 10 * 1000 // 10 seconds
    });

    function success(position) {
      latitude = position.coords.latitude;
      longitude = position.coords.longitude;

      var input1 =  $("<input>")
                    .attr("type", "hidden")
                    .attr("name", "lat_data")
                    .attr("value",latitude);
      var input2 =  $("<input>")
                    .attr("type", "hidden")
                    .attr("name", "long_data")
                    .attr("value",longitude);
      $('#search-form').append((input1));
      $('#search-form').append((input2));

      document.getElementById("search-form").submit();
    }

    function fail(msg) {
      alert("Please enable your geolocation service in order to find directions.");
    }
  })

  // SVG Hover
$('path').tooltip({
    'container': 'body',
    'placement': 'top'
  });
});
