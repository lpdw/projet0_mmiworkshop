//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require chartkick
//= require Chart.bundle
//= require highcharts
//= require_tree .

$(document).ready(function() {

	$('button.addinputassociated').each(function() {
		$(this).click(function() {
			var first_input_group = $(this).parent().prev().find('.form-group.associatedinputs').first();
			var element = first_input_group.clone();
			element.find('input').each(function(){$(this).val("")});
			first_input_group.parent().append(element);
			var inputbloc_class = $(this).parent().prev()[0].classList;
			listenEachAssociatedInputs(inputbloc_class[inputbloc_class.length-1]);
		});
	});

	$('div.inputsbloc').each(function(){
		listenEachAssociatedInputs(this.classList[this.classList.length-1]);
	})

});

var listenEachAssociatedInputs = function(inputbloc_class) {

	var inputsBloc = $('.' + inputbloc_class);

	$('.' + inputbloc_class + ' .form-group.associatedinputs').each(function() {

		$(this).find('input[type!=hidden]').first().autocomplete({
			query_result: [],
			source: function(request, response){
				$.ajax({
					url: "/autocomplete_feature",
					dataType: "json",
					data: {term: request.term, type: inputbloc_class},
					success: function(data) {
						var inputsId = [];
						inputsBloc.find('input[type=hidden]').each(function(){
							inputsId[inputsId.length] = $(this).val();
						});
						var autocomplete_values = [];
						var result = [];
						jQuery.each(data, function(i, val){
							if(jQuery.inArray(val.id.toString(), inputsId) == -1){
								autocomplete_values[autocomplete_values.length] = val.name_for_associated_inuts;
								result.push(val);
							}
						});
						query_result = result;
						response(autocomplete_values);
					}
				});
			},
			minLength: 2,
			select: function(event, ui) {
				var id;
				$.each(query_result, function(i, val) {
					if(ui.item.value == val.name_for_associated_inuts){
						id = val.id;
						return false;
					}
				});
				$(this).parent().find('input[type=hidden]').first().val(id);
			}
		});

	});

	$("#" + inputbloc_class).on("show.bs.modal", function(e) {
		var link = $(e.relatedTarget);
		$(this).find(".modal-content").load(link.attr("href"), function(){
			var id = [];
			var i = 0;
			inputsBloc.find("input[type=hidden]").each(function(){
				id[i] = $(this).val();
				i++;
			});
			$(this).find("input[type=checkbox]").each(function(){
				if (jQuery.inArray($(this).val(), id) != -1)
					$(this).parent().parent().remove();
				$(this).prop('checked', false);
				$(this).prop('name', '');
			});
		});
	});

};

var removeField = function(element) {
	if(element.parent().parent().parent().children('DIV').size()>1)
		element.parent().parent().remove();
	else
		element.parent().parent().find('input').each(function(){$(this).val("");});
};

var addFeaturesInputs = function(inputbloc_class) {
	$("#" + inputbloc_class).find("input[type=checkbox]:checked").each(function(){
		var element = $('.' + inputbloc_class).children("div.associatedinputs").last().clone();
		element.find('input[type=hidden]').first().val($(this).val());
		element.find('input').first().val($(this).parent().text());
		$('.' + inputbloc_class).append(element);
	});
	$('.' + inputbloc_class).children("div.associatedinputs").each(function(){
		if(!$(this).find("input[type=hidden]").first().val())
			$(this).remove();
	});
};

$(function() {
	$("#users_search input").keyup(function() {
		$.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
		return false;
	});
});
