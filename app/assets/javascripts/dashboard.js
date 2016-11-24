// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
    // Init de id
    id = "";



    // Au clique d'un badge
    $(".feature-check").click(function() {

        // On ouvre le modal

        $('#myModal').modal('show');
        id = this.id;
        // Init du modal
        if(Features[id].droit==1){
          $("#create_demande").css("display", "block");
          $('#commentaire_prof').attr("disabled", false);
          $('#comment').attr("disabled", false);
          // Si on est prof ou admin
          // On cache commentaire
          $('#comment').attr("disabled", true);
          // On ajoute le bouton de rejet
          $("#reject_demande").css("display", "block");


          value = Features[id].status == 1 ? "En attente de validation" : "Validé";
          value = Features[id].status == 3 ? "Rejeté" : value;
          button = Features[id].status == 1  ? 'Valider' : 'Modifier';
          $('#comment').val(Features[id].commentaire.replace(/&#39;/g, "'"));
          $('#commentaire_prof').val(Features[id].commentaire_prof.replace(/&#39;/g, "'"));
          if (Features[id].status == 2) {
              $("#create_demande").css("display", "none");
              $('#comment').attr("disabled", true);
              $('#commentaire_prof').attr("disabled", true);
              return;
          }
          $('#create_demande').html(button);
          $('#modal_status').html(value);
        }


        else if(Features[id].droit==0){
          $("#reject_demande").css("display",'none');
          $('#comment').attr("disabled", false);
          $('#comment').val(Features[id].commentaire.replace(/&#39;/g, "'"));
		    	$('#commentaire_prof').val(Features[id].commentaire_prof.replace(/&#39;/g, "'"));

          if(Features[id].status==2){
            value="Validé";
            $('#modal_status').html(value);

            $('#comment').attr("disabled", true);
            $('#commentaire_prof').attr("disabled", true);

            $("#create_demande").css("display", "none");

          }else if(Features[id].status==3){
            button = Features[id].status == 1  ? 'Valider' : 'Modifier';

            $("#reject_demande").css("display",'none');

            $('#comment').attr("disabled", false);
            value="Rejeté";
            $('#modal_status').html(value);

            $('#create_demande').html(button);

          }

        }

        $("#create_demande").click(function() {
            var comment = $('#comment').val();
            var comment_prof = $('#commentaire_prof').val();
            id_project = Features[id].project_id;
            params = {
                feature_id: id,
                project_id: id_project,
                status: '',
                commentaire: comment,
                commentaire_prof: comment_prof
            };
            $.ajax({
                type: "PUT",
                url: "/projects/" + id_project,
                data: {
                    data: params
                },
                success: function(data) {
                    // console.log(data);
                    location.reload();
                }
            });
        });
        $("#reject_demande").click(function() {
            var comment = $('#comment').val();
            var comment_prof = $('#commentaire_prof').val();
            id_project = $('#project').attr('data-id');
            params = {
                feature_id: id,
                project_id: id_project,
                status: '3',
                commentaire: comment,
                commentaire_prof: comment_prof
            };
            console.log(params);
            $.ajax({
                type: "PUT",
                url: "/projects/" + id_project,
                data: {
                    data: params
                },
                success: function(data) {
                    // console.log(data);
                    location.reload();
                }
            });
        });
    });

});
