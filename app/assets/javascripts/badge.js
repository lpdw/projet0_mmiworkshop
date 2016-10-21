$(function() {
	// Init de id
	var id = "";
	// Si on est dans un projet
	if( window.location.pathname.indexOf('projects') !== -1 ){
		// Au clique d'un badge
		$(".feature-badge").click(function() {
			// Exclusion si on à pas le droit
			if(Features.droit == 0){
				alert("Vous n\'avez pas le droit de faire une demande de badge, seul les membres du projet ainsi que leur professeur dispose de ce droit");
				return;
			}
			// On ouvre le modal
	    	document.getElementById('open_modal').click();
	    	id = this.id;
	    	// Si on est prof ou admin
	    	if(Features.droit == 2){
	    		// On cache commentaire
	    		$('#comment').attr("disabled", true);
	    		if(typeof Features[id] !== 'undefined'){
		    		// Si la demande a été faite on ajoute le bouton de rejet
		    		if(Features[id].status == 1 && Features[id].refuser == 'false'){$("#reject_demande").css("display", "block");}	    			
	    		}
	    	}
	    	// Sinon on disabled le commentaire prof
	    	else{$('#commentaire_prof').attr("disabled", true);}
	    	// Si c'est une nouvelle demande 
	    	if(typeof Features[id] === 'undefined'){
	    		value = "Aucun";
	    		button = Features.droit == 2 ? 'Validé' : 'Creer';
	    		$('#comment').val('');
		    	$('#commentaire_prof').val('');
	    	}
	    	else{
	    		value = Features[id].status == 1 ? "En attente de validation":"Validé";
	    		value = Features[id].refuser == 'true' ? "Rejeté" : value;
	    		button = Features[id].status == 1 && Features.droit == 2 ? 'Validé' : 'Modifié';
		    	$('#comment').val(Features[id].commentaire);
		    	$('#commentaire_prof').val(Features[id].commentaire_prof);
	    	}
	    	$('#create_demande').html(button);
	    	$('#modal_status').html(value);
	    	$("#create_demande").click(function() {
	    		var comment = $('#comment').val();
	    		var comment_prof = $('#commentaire_prof').val();
	    		id_project = $('#project').attr('data-id');
	    		params = {feature_id:id, project_id:id_project,status:'',commentaire:comment,reject:false,commentaire_prof:comment_prof};
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	// console.log(data);
			      	location.reload();
			      }
			    });
	    	});
	    	$("#reject_demande").click(function() {
	    		var comment = $('#comment').val();
	    		var comment_prof = $('#commentaire_prof').val();
	    		id_project = $('#project').attr('data-id');
	    		params = {feature_id:id, project_id:id_project,status:'',commentaire:comment,reject:true,commentaire_prof:comment_prof};
	    		console.log(params);
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	// console.log(data);
			      	location.reload();
			      }
			    });
	    	});
	  	});
	}
});