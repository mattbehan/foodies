// Initialization
function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 10
  });
  var geocoder = new google.maps.Geocoder();

  // Repositions map to restaurant
  geocodeAddress(geocoder, map);
}

// Jquery listener
$(document).ready(function() {

    // If the browser supports the Geolocation API
  if (typeof navigator.geolocation == "undefined") {
    $("#error").text("Your browser doesn't support the Geolocation API");
    return;
  }

  $("#from-link").click(function(event) {
    event.preventDefault();
    var addressId = this.id.substring(0, this.id.indexOf("-"));

    navigator.geolocation.getCurrentPosition(function(position) {
      var geocoder = new google.maps.Geocoder();
      geocoder.geocode({
        "location": new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      },
      function(results, status) {
        if (status == google.maps.GeocoderStatus.OK)
          $("#" + addressId).val(results[0].formatted_address);
        else
          $("#error").append("Unable to retrieve your address<br />");
      });
    },
    function(positionError){
      $("#error").append("Error: " + positionError.message + "<br />");
    },
    {
      enableHighAccuracy: true,
      timeout: 10 * 1000 // 10 seconds
    });
  });

  $("#calculate-route").submit(function(event) {
    event.preventDefault();
    var dynamicAddress = $('#street-address').html().concat($('#csz-address').html());
    calculateRoute($("#from").val(), dynamicAddress);
  });
});

function geocodeAddress(geocoder, resultsMap) {
  var dynamicAddress = $('#street-address').html().concat($('#csz-address').html());
  geocoder.geocode({'address': dynamicAddress}, function(results, status) {
    if (status === google.maps.GeocoderStatus.OK) {
      resultsMap.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
        map: resultsMap,
        position: results[0].geometry.location
      });
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}

function calculateRoute(from, to) {
  // Draw the map
  var mapObject = new google.maps.Map(document.getElementById("map"));

  var directionsService = new google.maps.DirectionsService();
  var directionsRequest = {
    origin: from,
    destination: to,
    travelMode: google.maps.DirectionsTravelMode.DRIVING,
    unitSystem: google.maps.UnitSystem.METRIC
  };
  directionsService.route(
    directionsRequest,
    function(response, status)
    {
      if (status == google.maps.DirectionsStatus.OK)
      {
        new google.maps.DirectionsRenderer({
          map: mapObject,
          directions: response
        });
      }
      else
        $("#error").append("Unable to retrieve your route<br />");
    }
  );
}

