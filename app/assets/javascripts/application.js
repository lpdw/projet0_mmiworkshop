//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap-sprockets
//= require chartkick
//= require highcharts
//= require_tree .
$(document).ready(function() {

	$('button.addinput').each(function() {
		var element = $(this).prev().find('input').first().clone();
		$(this).click(function() {
			$(this).prev().find('input').first().parent().append(element.clone().val(""));
		});
	});

	$('button.addinputdouble').each(function() {
		var firstElement = $(this).prev().find('input').first().clone();
		var secondElement = $(this).prev().prev().find('input').first().clone();
		$(this).click(function() {
			$(this).prev().find('input').first().parent().append(firstElement.clone().val(""));
			$(this).prev().prev().find('input').first().parent().append(secondElement.clone().val(""));
		});
	});

	// Add an input group (input text + hidden) to set multiple values.
	$('button.addinputassociated').each(function() {
		var element = $(this).prev().find('.form-group.associatedinputs').first().clone();
		element.find('input').each(function(){$(this).val("")});
		$(this).click(function() {
			$(this).prev().find('.form-group.associatedinputs').first().parent().append(element.clone());
			listenEachAssociatedInputs();
		});
	});

	listenEachAssociatedInputs();
});

var setInputValue = function(element, value){
	element.val(value);
};

// Listen each input group (that contains one input text and one input hidden)
// to set the feature id obtain width the feature name.
var listenEachAssociatedInputs = function(){

	$('.form-group.associatedinputs').each(function(){

		$(this).find('input[type=text]').first().autocomplete({
			query_result: null,
			source: function(request, response){
				$.ajax({
					url: "/autocomplete_feature",
					dataType: "json",
					data: {term: request.term},
					success: function(data) {
						query_result = data;
						var features_name = [];
						jQuery.each(data, function(i, val){
							features_name[i] = val.name;
						});
						response(features_name);
					}
				});
			},
			minLength: 2,
			select: function(event, ui) {
				var feature_id;
				jQuery.each(query_result, function(i, val){
					if(ui.item.value == val.name){
						feature_id = val.id;
						return false;
					}
				});
				setInputValue($(this).parent().find('input[type=hidden]').first(), feature_id);
			}
		});

		$(this).find('input[type=text]').first().bind("change paste keyup", function() {
			var element = $(this).parent();
			$.ajax({
				url: "/get_feature_id",
				type: "GET",
				data: {feature_name: $(this).val()},
				success: function(data){
					var feature_id = data[0];
					var hiddenInput = element.find('input[type=hidden]').first();
					if(feature_id){
						setInputValue(hiddenInput, feature_id);
					} else {
						setInputValue(hiddenInput, "");
					}
				}
			});
		});

	});

};