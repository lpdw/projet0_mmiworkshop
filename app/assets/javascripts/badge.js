$(function() {
	initFeatureModal();
});

var initFeatureModal = function() {
	// Si on est dans un projet
	if( window.location.pathname.indexOf('projects') !== -1 || window.location.pathname.indexOf('dashboard') !== -1 || window.location.pathname === "/"){
		// Au clique d'un badge
		$(".feature-badge, .feature-check").click(function(e) {
			// On annule la redirection vers la page du badge
			e.preventDefault();

			// Exclusion si on à pas le droit
			if(Features.droit == 0){
				alert("Vous n\'avez pas le droit de faire une demande de badge, seuls les membres du projet ainsi que leurs professeurs disposent de ce droit");
				return;
			}
			// On ouvre le modal
	    	$('#myModal').modal('show');
	    	var id = this.id;
	    	var id_feature = id;
	    	var value = "Validé";
	    	var id_project = $('#project').attr('data-id');
	    	// Init du modal
	    	$("#create_demande").css("display", "block");
	    	$('#commentaire_prof').attr("disabled", false);
	    	$('#comment').attr("disabled", false);
	    	// Si on est prof ou admin
	    	if(Features.droit == 2){
	    		// On cache commentaire
	    		$('#comment').attr("disabled", true);
	    		if(typeof Features[id] !== 'undefined'){
		    		// Si la demande a été faite on ajoute le bouton de rejet
		    		if(Features[id].status == 1){$("#reject_demande").css("display", "block");}
	    		}
	    	}
	    	// Sinon on disabled le commentaire prof
	    	else{$('#commentaire_prof').attr("disabled", true);}
	    	// Si c'est une nouvelle demande 
	    	if(typeof Features[id] === 'undefined'){
	    		value = "Non validé";
	    		button = Features.droit == 2 ? 'Valider' : 'Creer';
	    		$('#comment').val('');
		    	$('#commentaire_prof').val('');
	    	}
	    	else{
	    		id_feature = Features[id].feature_id;
	    		id_project = Features[id].project_id;
	    		if (Features[id].status == 1)
	    			value = "En attente de validation";
	    		else if (Features[id].status == 3)
	    			value = "Rejeté";
	    		button = (Features[id].status == 1 || Features[id].status == 3)  && Features.droit == 2 ? 'Valider' : 'Modifier';
		    	$('#comment').val(Features[id].commentaire.replace(/&#39;/g, "'"));
		    	$('#commentaire_prof').val(Features[id].commentaire_prof.replace(/&#39;/g, "'"));
		    	if(Features[id].status == 2){
		    		$('#modal_status').html(value);
		    		$('#create_demande').css("display", "none");
		    		$('#comment').attr("disabled", true);
		    		$('#commentaire_prof').attr("disabled", true);
		    		return;
		    	}
	    	}
	    	$('#create_demande').html(button);
	    	$('#modal_status').html(value);
	    	$('#create_demande').click(function() {
	    		var comment = $('#comment').val();
	    		var comment_prof = $('#commentaire_prof').val();
	    		params = {feature_id:id_feature, project_id:id_project,status:'',commentaire:comment,commentaire_prof:comment_prof};
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	location.reload();
			      }
			    });
	    	});
	    	$("#reject_demande").click(function() {
	    		var comment = $('#comment').val();
	    		var comment_prof = $('#commentaire_prof').val();
	    		params = {feature_id:id_feature, project_id:id_project,status:'3',commentaire:comment,commentaire_prof:comment_prof};
	    		$.ajax({
			      type: "PUT",
			      url: "/projects/"+id_project,
			      data: {data: params},
			      success:function(data){
			      	location.reload();
			      }
			    });
	    	});
	  	});
	}
}