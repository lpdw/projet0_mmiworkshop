$(function() {
	var id = "";
	if( window.location.pathname.indexOf('projects') !== -1 ){	    
		$(".feature-badge").click(function() {
	    	document.getElementById('open_modal').click();
	    	id = this.id;
	    	console.log($(this).attr("data-status"));
	    	$('#comment').val($(this).attr("data-commentaire"));
	    	if($(this).attr('data-status').length == 0){
	    		value = "Aucun";
	    		button = "Creer";
	    	}
	    	else{
	    		value = $(this).attr('data-status') == 1 ? "En attente de validation":"Valider";
	    		 
	    	}
	    	// $('#status').val(this.attr('data-status'));
	    	console.log("Val : ",value);
	    	$('#modal_status').html(value);
	    	$("#create_demande").click(function() {
	    		var comment = $('#comment').val();
	    		id_project = $('#project').attr('data-id');
	    		params = {feature_id:id, project_id:id_project,status:'',commentaire:comment};
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	console.log(data);
			      	// location.reload();
			      }
			    });
	    	});
	  	});
	}
});

function toto(users){
	console.log('Current users ', users);
}