$(function() {
  // Pagination AJAX
  $("#restaurants").on("click",".pagination a", function(){
    $(".pagination").html("Page is loading...");
    $.get(this.href, null, null, "script")
    return false
  })
});