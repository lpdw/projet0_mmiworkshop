// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require bootstrap.js
$(document).on("page:load ready", function(){
    $("input#dateDebut").datepicker({
      dateFormat: 'dd-mm-yy',
      minDate:0,
      onSelect:function(selectedDate){
        $('input#dateFin').datepicker('option', 'minDate', selectedDate || 0);

      }
    }
    );
    $("input#dateFin").datepicker({
      dateFormat: 'dd-mm-yy',
      onSelect:function(selectedDate){
        $('input#dateDebut').datepicker('option', 'maxDate', selectedDate || 0);

      }
    }
  );


});
