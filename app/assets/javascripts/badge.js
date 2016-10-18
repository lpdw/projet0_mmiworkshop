$(function() {
	var id = "";
	if( window.location.pathname.indexOf('projects') !== -1 ){	    
		$(".feature-badge").click(function() {
	    	document.getElementById('open_modal').click();
	    	id = this.id;
	    	console.log($(this).attr("data-commentaire"));
	    	$('#comment').val($(this).attr("data-commentaire"));
	    	// $('#status').val(this.attr('data-status'));
	    	$("#create_demande").click(function() {
	    		var comment = $('#comment').val();
	    		id_project = $('#project').attr('data-id');
	    		params = {feature_id:id, project_id:id_project,status:1,commentaire:comment};
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	console.log(data);
			      	location.reload();
			      }
			    });
	    	});
	  	});
	}
});