$(function() {
	if( window.location.pathname.indexOf('projects') !== -1 ){
		$(".feature-badge").click(function() {
	    	document.getElementById('open_modal').click();
	  });
	}
});