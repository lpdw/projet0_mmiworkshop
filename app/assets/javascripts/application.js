//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require chartkick
//= require Chart.bundle
//= require highcharts
//= require_tree .

$(function() {

  $("#users_search input").keyup(function() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
    return false;
  });
});
