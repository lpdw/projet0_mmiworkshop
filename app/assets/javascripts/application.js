//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require chartkick
//= require Chart.bundle
//= require highcharts
//= require_tree .
//= require_self

$(function() {
	$("#users_search input").keyup(function() {
		$.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
		return false;
	});
});