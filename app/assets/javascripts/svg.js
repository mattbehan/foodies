$(function() {

  $("path").on("click", function(){
    var neighborhood = $(this).attr("id")
    console.log(
      $(this).attr("id")
    );
    window.location.href = '/search'+"?search="+neighborhood;
  })

  $('path').tooltip({
    'container': 'body',
    'placement': 'top'
  });
});