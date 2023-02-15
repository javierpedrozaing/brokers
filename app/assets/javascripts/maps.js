// This example adds a marker to indicate the position of Bondi Beach in Sydney,
// Australia.

$(document).on('turbolinks:load', function(){
  getLocations();
});

function getLocations() {
  Rails.ajax({
    url: "/brokers_locations",
    type: "get",
    success: function(data) {     
      coordinates = data.map((data) => {
        return {
          coordinates: data.coordinates,
          name: data.name,
          photo: data.photo,
          city: data.city,
          phone: data.phone
        }
      });    
      //window.initMap = initMap();
      if (coordinates !== undefined) {
        initMap(coordinates);
      }
      
    },    
    error: function(data) {
      console.error(data);
    }
  })
};


function initMap(locations) {
  latitude = locations ? locations[0].coordinates[0] : ""
  longitude = locations ? locations[0].coordinates[1] : ""

  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 5,
    center: { lat: latitude, lng:  longitude },
  });

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
        };
        
        map.setCenter(pos);
      },
      () => {
        handleLocationError(true, infoWindow, map.getCenter());
      }
    );
  } else {
    // Browser doesn't support Geolocation
    handleLocationError(false, infoWindow, map.getCenter());
  }

  const image =
  "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png";
    
  var marker, i;
  
  for (i = 0; i < locations.length; i++) {

    const infowindow = new google.maps.InfoWindow({
      content: "<div>"
      + "<div style='display: flex;align-items: center;justify-content: space-around;'><img style='width: 20%;' src='"+ locations[i].photo +"'></div>"
      + "<div style='display: flex;align-items: center;justify-content: space-around;'>Hola Soy, " + locations[i].name +
      " y estoy en la ciudad de " + locations[i].city + "</div><br/><p>Call me: " + locations[i].phone + "</p></div>",
    });

    console.log(locations);
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i].coordinates[0], locations[i].coordinates[1]),
      map: map,
      icon: image,
    });
    
    google.maps.event.addListener(marker, 'click', (function(marker, i) {
      return function() {
        // infowindow.setContent(locations[i][0]);
        infowindow.open(map, marker);
      }
    })(marker, i));
  }  
}