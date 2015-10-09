// function ajax_signup() {
// 	$("#new_user").on("submit", function(event){
// 		event.preventDefault();
		
// 		console.log("after default")

// 		var data = $(this).serialize();
// 		var action = $(this).attr("action")
// 		var method = $(this).attr("method")
// 		var request = $.ajax({
// 			method: method,
// 			data: data,
// 			url: action
// 		})
// 		request.done(function(response){

// 		});
// 		request.fail(function(response){

// 		});
// 	})
// }