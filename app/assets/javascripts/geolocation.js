$(function() {
  $(".search-form").on("submit", function(event){
    event.preventDefault();
    $this = this;
    $('.search-bar').addClass('loadinggif');

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
      $('.search-form').append((input1));
      $('.search-form').append((input2));

      $this.submit();
    }

    function fail(msg) {
      alert("Please enable your geolocation service in order to find directions.");
    }
  })
});