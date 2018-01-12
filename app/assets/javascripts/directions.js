// function coordinates(response){
//   var locationObj = response.coords;
//   return locationObj
// }


function getDirections(dest){
  console.log("butts")
  $('.main-map').css('display', 'none')
  $('.direction-map').css('display', 'block')
  var directionsDisplay = new google.maps.DirectionsRenderer();
  var directionsService = new google.maps.DirectionsService();


  function calcRoute() {
    var origin      = new google.maps.LatLng(userLatitude, userLongitude);
    var destination = new google.maps.LatLng(dest.latitude, dest.longitude);
    var request = {
        origin:      origin,
        destination: destination,
        travelMode:  google.maps.TravelMode.DRIVING
    };
    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
      }
    });
  }

  calcRoute();

  var handler = Gmaps.build('Google');
  handler.buildMap({ internal: {id: 'directions'}}, function(){
    directionsDisplay.setMap(handler.getMap());
    directionsDisplay.setPanel(document.getElementById('right-panel'));
    var currentMarker = handler.addMarker({
      lat: userLatitude,
      lng: userLongitude
    });
    handler.map.centerOn(currentMarker);
  });
}

function getCustomerDirections(dest){
  console.log("restful")
  var directionsDisplay;
  var directionsService = new google.maps.DirectionsService();
  var map;

  function initialize() {
    directionsDisplay = new google.maps.DirectionsRenderer();
    var mapOptions = {
      zoom:7
    }
    map = new google.maps.Map(document.getElementById('directions'), mapOptions);
    directionsDisplay.setMap(map);
  }

  function calcRoute() {
    var origin      = new google.maps.LatLng(userLatitude, userLongitude);
    var destination = new google.maps.LatLng(26.5631695, -80.1044279);
    var request = {
        origin:      origin,
        destination: destination,
        travelMode:  google.maps.TravelMode.DRIVING
    };
    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
      }
    });
  }

  calcRoute();
}
