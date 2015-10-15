	$(document).ready(function() { 
		var $winwidth = $(window).width();
		$("img.source-image").attr({
			width: $winwidth
		});
		$(window).bind("resize", function(){ 
			var $winwidth = $(window).width();
			$("img.source-image").attr({
				width: $winwidth
			});
		 });
	}); 
</script>