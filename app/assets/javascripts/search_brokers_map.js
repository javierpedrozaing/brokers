// This example adds a marker to indicate the position of Bondi Beach in Sydney,
// Australia.

$(document).on('turbolinks:load', function(){
  getSearchLocations();

  $("#search-brokers").on('click', () => {
    let country = $("#country").val();
    let state = $("#state").val();
    let city = $("#city").val();
    
    let mydata = {location: {country: country, state: state, city: city}}
    debugger
    Rails.ajax({
      url: "/search_brokers",
      type: "post",
      data: JSON.stringify(mydata),
      success: function(position) {  
        getSearchLocations(position);
      },    
      error: function(data) {
        console.error(data);
      }
    })
  })
});



function getSearchLocations(position = null) {
  Rails.ajax({
    url: "/brokers_locations",
    type: "get",
    success: function(data) {     
      coordinates = data.map((data) => {
        return {
          coordinates: data.coordinates,
          name: data.name,
          photo: data.photo,
          city: data.city
        }
      });    
      //window.initMap = initMap();
      initSearchMap(coordinates, position);
    },    
    error: function(data) {
      console.error(data);
    }
  })
};


function initSearchMap(locations, position = null) {
  latitude = locations ? locations[0].coordinates[0] : ""
  longitude = locations ? locations[0].coordinates[1] : ""

  const map = new google.maps.Map(document.getElementById("map-brokers"), {
    zoom: 12,
    center: { lat: latitude, lng:  longitude },
  });

  if (position != null) {  
    const newpos = {
      lat: position[0],
      lng: position[1]
    }
    map.setCenter(newpos);
  } else {

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
  
  }


  const image =
  "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png";
    
  var marker, i;
  
  for (i = 0; i < locations.length; i++) {

    const infowindow = new google.maps.InfoWindow({
      content: "<div>"
      + "<div style='display: flex;align-items: center;justify-content: space-around;'><img style='width: 20%;' src='"+ locations[i].photo +"'></div>"
      + "<div style='display: flex;align-items: center;justify-content: space-around;'>Hola Soy, " + locations[i].name +
      " y estoy en la ciudad de " + locations[i].city + "</div></div>",
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
