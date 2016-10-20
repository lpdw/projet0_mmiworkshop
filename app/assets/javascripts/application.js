//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require chartkick
//= require Chart.bundle
//= require highcharts
//= require_tree .

$(function() {
  $("#users th a, #users .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#users_search input").keyup(function() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
    return false;
  });
});
