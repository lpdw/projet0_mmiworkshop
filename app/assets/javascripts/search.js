$(document).ready(function() {

	$('input.search-users').each(function(){
		var oldValue = null;
		$(this).on("change keyup paste", function(){
			var value = $(this).val();
			if(value) {
				if(value.length > 2 && value != oldValue) {
					oldValue = value
					searchUsers(value);
				}else if(oldValue && oldValue.length > 2 && value.length <= 2){
					oldValue = value
					searchUsers("");
				}
			}
		});
	});

	$('input.search-features').each(function(){
		var oldValue = null;
		$(this).on("change keyup paste", function(){
			var value = $(this).val();
			var project_id = $(this).attr("project_id");
			if(value && project_id) {
				if(value.length > 2 && value != oldValue) {
					oldValue = value
					searchFeatures(value, project_id);
				}else if(oldValue && oldValue.length > 2 && value.length <= 2){
					oldValue = value
					restoreFeatures();
				}
			}
		});
	});

});

var searchUsers = function(value) {
	$.ajax({
		url: "/search_users",
		dataType: "json",
		data: {'search': value},
		success: function(data) {
			$('div.row.users').html(data.html);
		}
	});
};

var searchFeatures = function(value, project_id) {
	$.ajax({
		url: "/search_features",
		dataType: "json",
		data: {'search': value, 'project_id': project_id},
		success: function(data) {
			$("#searchFeatures").remove();
			$("#sortFeatures").hide().after(data.html);
			initFeatureModal();
		}
	});
};

var restoreFeatures = function() {
	$("#sortFeatures").show();
	$("#searchFeatures").remove();
};