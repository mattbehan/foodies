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
    $("#rest-of-specialties").show();
    $("#new-specialties-form").show();
  })
  // SearchBar geolocation
  $("#search").click(function(event) {
    event.preventDefault();
    // Method 1
    var latitude, longitude;
    navigator.geolocation.getCurrentPosition(success, fail,
    {
      enableHighAccuracy: true,
      timeout: 10 * 1000 // 10 seconds
    });

    function success(position) {
      latitude = position.coords.latitude;
      longitude = position.coords.longitude;
      $("#lat-data").val(latitude);
      $("#long-data").val(longitude);
      // $("#get-directions").attr("href", "https://www.google.com/maps/dir/"
      //   + latitude + "," + longitude + "/" +
      //   $('#street-address').html().concat($('#csz-address').html()));
      // window.location.href = $("#get-directions").attr("href");
    }

    function fail(msg) {
      alert("Please enable your geolocation service in order to find directions.");
    }
    // Method 2
    // navigator.geolocation.getCurrentPosition(function(position) {
    //   var geocoder = new google.maps.Geocoder();
    //   geocoder.geocode(
    //     {
    //       "location": new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    //     },
    //     function(results, status) {
    //       if (status == google.maps.GeocoderStatus.OK) {

    //         console.log("in");
    //         console.log(results[0].formatted_address);
    //         // $("#" + addressId).val(results[0].formatted_address);
    //       } else {
    //         console.log("else")
    //         // $("#error").append("Unable to retrieve your address<br />");
    //       }
    //     }
    //   );
    // },
    // function(positionError){
    //   $("#error").append("Error: " + positionError.message + "<br />");
    // },
    // {
    //   enableHighAccuracy: true,
    //   timeout: 10 * 1000 // 10 seconds
    // });
  })  


//   var x = document.getElementById("demo");

//   $("location-submitter").on("click", )
//     if (navigator.geolocation) {
//         return navigator.geolocation.getCurrentPosition();
//     } else { 
//         x.innerHTML = "Geolocation is not supported by this browser.";
//     }
// }

  // SVG Hover
  $("path").on("mouseover", function(){
    $("#neighborhood").html($(this).attr("id"));
  })
});
