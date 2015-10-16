$(function() {
  $("path").on("click", function(){
    var neighborhood = $(this).attr("id")

    var latitude, longitude;
    navigator.geolocation.getCurrentPosition(success, fail,
    {
      enableHighAccuracy: true,
      timeout: 10 * 1000 // 10 seconds
    });

    function success(position) {
      latitude = position.coords.latitude;
      longitude = position.coords.longitude;

      window.location.href = '/search'+"?search="+neighborhood+"&lat_data="+latitude+"&long_data="+longitude
    }

    function fail(msg) {
      alert("Please enable your geolocation service in order to find directions.");
    }
  })

  $('path').tooltip({
    'container': 'body',
    'placement': 'top'
  });
});