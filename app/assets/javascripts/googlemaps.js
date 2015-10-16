$(function() {
// Initialization
    // map theme

    var styleArray = [{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"on"},{"lightness":33}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2e5d4"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#c5dac6"}]},{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"},{"lightness":20}]},{"featureType":"road","elementType":"all","stylers":[{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#c5c6c6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#e4d7c6"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#fbfaf7"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#acbcc9"}]}]
    // marker theme
    var pinImage

    function initMap() {
      var pinColor = "810541";
      pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34));
      var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 15,
        styles: styleArray
      });
      var geocoder = new google.maps.Geocoder();
      // Repositions map to restaurant
      geocodeAddress(geocoder, map);

      // Mobile version
      var mobileMap = new google.maps.Map(document.getElementById('mobile-map'), {
        zoom: 15,
        styles: styleArray
      });
      var geocoder = new google.maps.Geocoder();
      // Repositions map to restaurant
      geocodeAddress(geocoder, mobileMap);
    }

// Jquery listener
    $(document).ready(function() {

        // If the browser supports the Geolocation API
      if (typeof navigator.geolocation == "undefined") {
        $("#error").text("Your browser doesn't support the Geolocation API");
        return;
      }

      $("#get-directions").click(function(event) {
        event.preventDefault();
        var latitude, longitude;
        navigator.geolocation.getCurrentPosition(success, fail);

        function success(position) {
          latitude = position.coords.latitude;
          longitude = position.coords.longitude;
          $("#get-directions").attr("href", "https://www.google.com/maps/dir/"
            + latitude + "," + longitude + "/" +
            $('#street-address').html().concat($('#csz-address').html()));
          window.location.href = $("#get-directions").attr("href");
        }

        function fail(msg) {
          alert("Please enable your geolocation service in order to find directions.");
        }

      })

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

// Helper functions
    function geocodeAddress(geocoder, resultsMap) {
      var dynamicAddress = $('#street-address').html().concat($('#csz-address').html());
      geocoder.geocode({'address': dynamicAddress}, function(results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
          resultsMap.setCenter(results[0].geometry.location);
          var marker = new google.maps.Marker({
            map: resultsMap,
            position: results[0].geometry.location,
            icon: pinImage,
            animation: google.maps.Animation.DROP
          });
        } else {
          alert('Geocode was not successful for the following reason: ' + status);
        }
      });
    }

    function calculateRoute(from, to) {
      // Draw the map

      var mapObject = new google.maps.Map(document.getElementById("map"), {
        zoom: 10,
        styles: styleArray
      });

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
              directions: response,
              polylineOptions: {
                strokeColor: "#810541",
                strokeOpacity: 0.4
              },
              markerOptions: {
                opacity: 0.85,
                setAnimation: google.maps.Animation.DROP
              }
            });
          }
          else
            $("#error").append("Unable to retrieve your route<br />");
        }
      );
    }
});
