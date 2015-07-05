// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require_tree .
$(document).ready(function() {
	$(window).scroll(function() {
		if ($(window).scrollTop() >= $(document).height() - $(window).height() - 10) {
			$('#next_link').trigger("click");
		}
	});
	$(".search_cond").click(function() {
		var cond_year = "";
		if ($(this).attr("name") == "cy") {
			cond_year = $(this).attr("value");
		} else {
			cond_year = $(".y").attr("value");
		}

		var cond_month = "";
		var cond_month_list = $(".m:checked").map(function() {
			return $(this).val();
		});
		for (var i = 0; i <= cond_month_list.length - 1; i++) {
			cond_month += cond_month_list[i];
			if (i < cond_month_list.length - 1) {
				cond_month += ",";
			}
		}

		var cond_day = "";
		var cond_day_list = $(".d:checked").map(function() {
			return $(this).val();
		});
		for (var i = 0; i <= cond_day_list.length - 1; i++) {
			cond_day += cond_day_list[i];
			if (i < cond_day_list.length - 1) {
				cond_day += ",";
			}
		}
		location.href = "/list?y=" + cond_year + "&m=" + cond_month + "&d=" + cond_day + "&page=1";
	});
});
