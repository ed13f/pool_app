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
//= require rails-ujs
//= require turbolinks
//= require underscore
//= require bootstrap-sprockets
//= require_tree .
//= require jquery.validate.additional-methods 
//= require jquery.validate
//= require rails.validations

$( document ).ready(function() {
	$(document).on('turbolinks:load', function() {
        setTimeout(function() { google.maps.event.trigger(map, 'resize') }, 600);
		//Gear Icon Show More Settings
		$('body').on('click', '.fa-gear.customer, .fa-gear.repair', function(){
		 	var wrapper = $(this).closest('.icon-wrapper');
		 	var dropDown = wrapper.siblings('.settings-drop-down');
		 	if(dropDown.hasClass('active')){
		 		dropDown.removeClass('active');
		 	} else{
		 		dropDown.addClass('active');
		 	}
		})
		//Drop Down Show More Options
		$('body').on('click', '.more-info', function(){
		 	var header = $(this).closest('header');
		 	var icon = $(this).find("i");
		 	var moreSection = header.siblings('.more-section');
		 	if(moreSection.hasClass('active')){
		 		moreSection.removeClass('active');
		 		icon.removeClass('active');
		 	} else{
		 		moreSection.addClass('active');
		 		icon.addClass('active');
		 	}
		})
		//form input focus
		$('body').on('focus', '.input-wrapper input, .input-wrapper textarea', function(){
			// debugger
		  $(this).removeClass('error');
	      $(this).siblings("label").addClass("active-input")
	    })
	    $('body').on('focusout', '.input-wrapper input, .input-wrapper textarea', function(){
	      var activeInput = $(this);
	      // debugger
	      if(activeInput.val() == '' && activeInput.attr('placeholder') == null){
	        $(this).siblings("label").removeClass("active-input");
	      } else if(activeInput.attr('placeholder') == null){
	      	$(this).siblings("label").removeClass("error");
	      }  
	    })
		// Option Nav Toggle
		$('.options-nav .switch').on('click', function(){
			var tab = $(this);
			if(!tab.hasClass('active-switch')){
				$('.options-nav').find('.switch').removeClass('active-switch');
				tab.addClass('active-switch');
				$('.pool-lists').removeClass('active-list');
				$('.new-link').removeClass('active-link');
				if(tab.hasClass('todays-switch')){
					$('.todays-pool-list').addClass('active-list');
				}else if(tab.hasClass('master-switch')){
					$('.master-pool-list').addClass('active-list');
				}else if(tab.hasClass('map-switch')){
					$('.map-pool-list').addClass('active-list');
				}else if(tab.hasClass('history-switch')){
					$('.history-list').addClass('active-list');
				}
				else if(tab.hasClass('details-switch')){
					$('.details-list').addClass('active-list');
				}
				else if(tab.hasClass('repair-switch')){
					$('.repairs-list').addClass('active-list');
				}
				else if(tab.hasClass('employees-switch')){
					$('.employees-list').addClass('active-list');
					$('.new-employee-link').addClass('active-link');
				}
				else if(tab.hasClass('customers-switch')){
					$('.customers-list').addClass('active-list');
					$('.new-customer-link').addClass('active-link');
				}
			}
		})
		// Form Cancel Close Slider
		$('#customer-edit-form, #user-form, #repair-form, #visit-form, #business-form').on('click', 'button.cancel', function(){
			$('#customer-edit-form, #user-form, #repair-form, #visit-form, #business-form').removeClass('active');
		})
		//Mobile Nav Button
		$(".mobile-menu-button").on("click", function(){
			if($(this).hasClass("clicked")){
				$(this).removeClass("clicked")
				$("#menu-main-menu").removeClass("active-nav-menu")
				$('.nav-wrapper').removeClass('active');
			}else{
				$(this).addClass("clicked")
				$("#menu-main-menu").addClass("active-nav-menu")
				$('.nav-wrapper').addClass('active');
			}
		})
		//Bounce Browser
		$(document).bind(
			'touchmove',
			function(e) {
				e.preventDefault();
			}
		);
		//FormValidation  
		 //   $("#new_customer").validate({
		 //   	debug: true,
			//   rules: {
			//     'customer[first_name]': 'required'
			//   }
			// });
		   $("#new_customer").validate({
				debug: true,
				rules: {
					"customer[first_name]": {required: true}
				}
			});
		//Search Functionality
		function searchSortCustomers(customer, value){
			return customer.first_name.toUpperCase().indexOf(value) >= 0  || 
			customer.last_name.toUpperCase().indexOf(value) >= 0 || 
			customer.email.toUpperCase().indexOf(value) >= 0 || 
			customer.phone.toUpperCase().indexOf(value) >= 0 || 
			customer.city.toUpperCase().indexOf(value) >= 0 || 
			customer.street_address.toUpperCase().indexOf(value) >= 0
		}
		function searchSortUsers(user, value){
			return user.first_name.toUpperCase().indexOf(value) >= 0  || 
			user.last_name.toUpperCase().indexOf(value) >= 0 ||
			user.phone.toUpperCase().indexOf(value) >= 0 ||
			user.email.toUpperCase().indexOf(value) >= 0
		}
		function searchSortrepairs(repair, value){
			return repair.title.toUpperCase().indexOf(value) >= 0  || 
			repair.description.toUpperCase().indexOf(value) >= 0
		}
		function displaySearchResults( objectName, value, listSelector, cardSelector ){
			var searchResults = [];
			var jsonList = JSON.parse(localStorage.getItem(objectName));
			if(jsonList != null){
				for(var i = 0; i < jsonList.length; i++) {
					var jsonObject = jsonList[i];
					var queryConditional = false;
					var alertType = "Result"
					if(objectName == "businessCustomers" || objectName == "userCustomers" || objectName == "userTodaysCustomers"){
						queryConditional = searchSortCustomers(jsonObject, value)
						alertType = "Customers"
					} else if(objectName == "businessUsers"){
						queryConditional = searchSortUsers(jsonObject, value);
						alertType = "Employee"
					} else if(objectName == "repairsOpenRepairs" || objectName == "repairsAll"){
						queryConditional = searchSortrepairs(jsonObject, value)
						alertType = "Repair"
					}
					if (queryConditional)  {
						selector = listSelector + " " + cardSelector + jsonObject.id;
						$(selector).addClass("search-display");
						searchResults.push(jsonObject.id);
					}
				}
				if(searchResults.length == 0){
					$(".constant-no-results").addClass("hide");
					$(listSelector).prepend("<h2 class='search-alert'>No " + alertType + " Found.</h2>");
				}else{
					$(".constant-no-results").removeClass("hide");
				}
				var lastCardId = searchResults.pop();
				selector = cardSelector + lastCardId;
				$(listSelector  + " " + selector).addClass("no-border");
			}
		}
		$('body').on('input', "input[name='customer[phone]'], input[name='user[phone]']", function(e){
			var output,
		      $this = $(this),
		      input = $this.val();
		      
		      if(/\)$/.test(input) || /\-$/.test(input)){
		      	output = input.substring(0, input.length - 1);
		      	$this.val(output);
		      	return
		      } else if(/\)\s$/.test(input)){
		      	output = input.substring(0, input.length - 2);
		      	$this.val(output);
		      	return
		      } else if(/\($/.test(input) || input == ""){
		      	output = "";
		      	$this.val(output);
		      	return
		      }
		    if(e.keyCode != 8) {
		      input = input.replace(/[^0-9]/g, '');
		      var area = input.substr(0, 3);
		      var pre = input.substr(3, 3);
		      var tel = input.substr(6, 4);
		      if (area.length < 3) {
		        output = "(" + area;
		      } else if (area.length == 3 && pre.length < 3) {
		        output = "(" + area + ") " + pre;
		      } else if (area.length == 3 && pre.length < 3) {
		        output = "(" + area + ")" + " " + pre;
		      } else if (area.length == 3 && pre.length == 3) {
		        output = "(" + area + ")" + " " + pre + "-" + tel;
		      }
		      $this.val(output);
		    }
		})
		$('.search').on('input', function(){
			var cards = $(".card");
			var val = $(this).val().toUpperCase();
			cards.removeClass("search-hide search-display no-border");
			$(".card").removeClass("search-display");
			$(".card").addClass("search-hide");
			$(".search-alert").remove();
			if(val !=""){
				// Business Customers
				displaySearchResults( "businessCustomers", val, ".business-customers .customers.card-list .list", ".customer-card-" );
				// Business Employees
				displaySearchResults( "businessUsers", val, ".business-users .users.card-list .list", ".user-card-" );
				// Repairs Open Repairs
				displaySearchResults( "repairsOpenRepairs", val, ".repairs-open-repairs .repairs.card-list .list", ".repair-card-" );
				// Repairs All
				displaySearchResults( "repairsAll", val, ".repairs-all .repairs.card-list .list", ".repair-card-" );
				// Users Customers
				displaySearchResults( "userCustomers", val, ".user-customers .customers.card-list .list", ".customer-card-" );
				// Users Todays Customers
				displaySearchResults( "userTodaysCustomers", val, ".user-todays-customers .customers.card-list .list", ".customer-card-" );
			} else{
		  		$(".card").removeClass("search-hide");
		    } 
			val = $(this).val();
			$('.search').val(val)
		})
	});
})
