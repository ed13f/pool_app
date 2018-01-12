// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require rails-ujs
//= require turbolinks
//= require underscore
//= require gmaps/google
//= require bootstrap-sprockets
//= require_tree .


var userLatitude;
var userLongitude;
var watchId;

$( document ).ready(function() {
	$(document).on('turbolinks:load', function() {
		function coordErrors(err){
			console.warn('ERROR(' + err.code + '): ' + err.message);
		}

		 var options = {
		  enableHighAccuracy: true,
		  timeout: 5000,
		  maximumAge: 0
		};

		function coordinates(response){
		  userLatitude = response.coords.latitude;
		  console.log(userLatitude)
		  userLongitude = response.coords.longitude;
		  console.log(userLongitude)
		}
		watchId = navigator.geolocation.watchPosition(coordinates, coordErrors, options);
		$("#complete-trip").on("click", function(){
			console.log("complete");
			$("#right-panel").empty();
			$(".direction-map").css("display", "None");
			$(".main-map").css("display", "block");
		})


		$("#master-switch").on("click", function(){
			console.log("complete click")
			$("#master-switch").addClass("active-switch")
			$("#complete-switch").removeClass("active-switch")
			$("#incomplete-switch").removeClass("active-switch")
			$("#map-switch").removeClass("active-switch")
			$("#master-sheet").css("display", "inline-block");
			$("#finished-pools").css("display", "none");
			$("#unfinished-pools").css("display", "none");
			$("#pool-maps").css("display", "none");
		})
		$("#incomplete-switch").on("click", function(){
			console.log("incomplete click")
			$("#incomplete-switch").addClass("active-switch")
			$("#complete-switch").removeClass("active-switch")
			$("#master-switch").removeClass("active-switch")
			$("#map-switch").removeClass("active-switch")
			$("#unfinished-pools").css("display", "inline-block");
			$("#finished-pools").css("display", "none");
			$("#master-sheet").css("display", "none");
			$("#pool-maps").css("display", "none");
		})
		$("#complete-switch").on("click", function(){
			console.log("complete click")
			$("#complete-switch").addClass("active-switch")
			$("#incomplete-switch").removeClass("active-switch")
			$("#master-switch").removeClass("active-switch")
			$("#map-switch").removeClass("active-switch")
			$("#finished-pools").css("display", "inline-block");
			$("#unfinished-pools").css("display", "none")
			$("#master-sheet").css("display", "none");
			$("#pool-maps").css("display", "none");
		})
		$("#map-switch").on("click", function(){
			$("#map-switch").addClass("active-switch");
			$("#complete-switch").removeClass("active-switch");
			$("#incomplete-switch").removeClass("active-switch");
			$("#master-switch").removeClass("active-switch");
			$("#pool-maps").css("display", "block");
			$("#unfinished-pools").css("display", "none");
			$("#finished-pools").css("display", "none");
			$("#master-sheet").css("display", "none");
		})
		$("#open-repair-switch").on("click", function(){
			$("#open-repair-switch").addClass("active-repair-tab");
			$("#repair-history-switch").removeClass("active-repair-tab");
			$("#open-repairs").css("display", "inline-block");
			$("#finished-repairs").css("display", "none");
		})
		$("#repair-history-switch").on("click", function(){
			$("#repair-history-switch").addClass("active-repair-tab");
			$("#open-repair-switch").removeClass("active-repair-tab");
			$("#finished-repairs").css("display", "inline-block");
			$("#open-repairs").css("display", "none");
		})
	});
})