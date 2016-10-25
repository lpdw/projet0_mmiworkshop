//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap-sprockets
//= require chartkick
//= require Chart.bundle
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
		var element = $(this).parent().prev().find('.form-group.associatedinputs').first().clone();
		element.find('input').each(function(){$(this).val("")});
		$(this).click(function() {
			$(this).parent().prev().find('.form-group.associatedinputs').first().parent().append(element.clone());
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

		$(this).find('input').first().autocomplete({
			query_result: [],
			source: function(request, response){
				$.ajax({
					url: "/autocomplete_feature",
					dataType: "json",
					data: {term: request.term},
					success: function(data) {
						console.log(data);
						var id = [];
						var i = 0;
						$("input[type=hidden][name='project[feature_ids][]']").each(function(){
							id[i] = $(this).val();
							i++;
						});
						var features_name = [];
						var result = [];
						jQuery.each(data, function(i, val){
							if(jQuery.inArray(val.id.toString(), id) == -1){
								features_name[features_name.length] = val.name_with_category;
								result.push(val);
							}
						});
						query_result = result;
						response(features_name);
					}
				});
			},
			minLength: 2,
			select: function(event, ui) {
				var feature_id;
				$.each(query_result, function(i, val){
					if(ui.item.value == val.name_with_category){
						feature_id = val.id;
						return false;
					}
				});
				setInputValue($(this).parent().find('input[type=hidden]').first(), feature_id);
			}
		});

	});

	$("#myModal").on("show.bs.modal", function(e) {
		var link = $(e.relatedTarget);
		$(this).find(".modal-content").load(link.attr("href"), function(){
			var id = [];
			var i = 0;
			$("input[type=hidden][name='project[feature_ids][]']").each(function(){
				id[i] = $(this).val();
				i++;
			});
			$("input[type=checkbox][name='project[feature_ids][]']").each(function(){
				if (jQuery.inArray($(this).val(), id) != -1) {
					$(this).parent().parent().remove();
				}
			});
		});
	});

};

var removeField = function(element){
	if(element.parent().parent().parent().children('DIV').size()>1)
		element.parent().parent().remove();
	else
		element.parent().parent().find('input').each(function(){$(this).val("");});
}

var addFeaturesInputs = function(){
	$("input[type=checkbox][name='project[feature_ids][]']:checked").each(function(){
		var element = $("div.project_features").first().children("div.associatedinputs").last().clone();
		while(!$("div.project_features").first().children("div.associatedinputs").last().find('input[type=hidden]').first().val()){
			$("div.project_features").first().children("div.associatedinputs").last().remove();
		}
		element.find('input[type=hidden]').first().val($(this).val());
		element.find('input').first().val($(this).parent().text());
		$("div.project_features").first().append(element);
	});
}

$(function() {
	$("#users_search input").keyup(function() {
		$.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
		return false;
	});
});
