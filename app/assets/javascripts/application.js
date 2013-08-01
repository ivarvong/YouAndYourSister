// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var report_like_time = function(subevent, start_time) {
	var delta_time = (new Date()).getTime() - start_time;
	ga('send', {
		'hitType': 'timing',
		'timingCategory': 'create-like',
		'timingVar': 'create-like-'+subevent,
		'timingValue': delta_time,
		'timingLabel': subevent
	});
}

var report_ready_time = function(end_time) {
	window.have_reported_dom_ready = true;
	var delta_time = window.top_of_page_time - end_time;
	ga('send', {
		'hitType': 'timing',
		'timingCategory': 'DOM Ready',
		'timingVar': 'DOM Ready',
		'timingValue': delta_time
	});
}

var ready = function() {
	if (window.have_reported_dom_ready === false) {
		report_ready_time(new Date().getTime());
	}
	
	$.ajaxSetup({
	  headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
	});
	
	$('.like-button').click(function(e) {
		e.preventDefault();
		if (window.is_logged_in === false) {
			$('.modal').fadeIn(150);
			return false;			
		}

		var _start_time = (new Date()).getTime();
		
		var post_id = $(this).attr('data-post-id')
		$.post("/like", { 'post_id': post_id }, function(response) {
	    	$(".post-"+post_id).find('.like-count').html(response);
	    	report_like_time('success', _start_time);
	  	}).fail(function(error){
	  		$('.only-vote-once').fadeIn(400).delay(50).fadeOut(900);
	  		report_like_time('failure', _start_time);
	  	});
	});

	$('.dismiss-modal').click(function(e) {
		e.preventDefault();
		$('.modal').fadeOut(150);
	})
	
	$('.post .meta').hide();
	$('.post').hover(function(){
		$(this).find('.meta').fadeIn()
		ga('send', 'event', 'plus-button', 'hover');
	}, function() {
		$(this).find('.meta').fadeOut()
	});

	$('.yes-button').hover(function() {
		$(this).animate({'opacity': '0.6'}, 100);
	}, function() {
		$(this).animate({'opacity': '1.0'}, 100);
	})

	$('.submit-action').hover(function() {
		$(this).addClass('submit-hovering');
	}, function() {
		$(this).removeClass('submit-hovering');	
	})
}
$(document).ready(ready)
$(document).on('page:load', ready)