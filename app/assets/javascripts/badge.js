$(function() {
	var id = "";
	if( window.location.pathname.indexOf('projects') !== -1 ){
		$(".feature-badge").click(function() {
	    	document.getElementById('open_modal').click();
	    	// console.log(this.id);
	    	id = this.id;
	    	$("#create_demande").click(function() {
	    		console.log("Id : ",id);
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/1",
			      data: {feature_id: id},
			      success:function(data){
			      	console.log(data);
			      }
			    });
	    	});
	  	});
	}
});