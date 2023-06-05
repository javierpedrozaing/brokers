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
      locations = data.map((data) => {
        photo = data.photo ? data.photo : 'https://sleepy-garden-18861.herokuapp.com/assets/profile-c6176daa79e0b765aaa2547b00b4f89cc40ca69e274ddcc123d271cd0a0ac574.png';
        return {
          coordinates: data.coordinates,
          name: data.name,
          photo: photo,
          city: data.city,
          phone: data.phone
        }
      });
      initMap(locations);
    },    
    error: function(data) {
      console.error(data);
    }
  })
};


function initMap(locations) {
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 5,
  });

  latitude = (locations && locations[0]?.coordinates) ? locations[0]?.coordinates[0] : ""
  longitude = (locations && locations[0]?.coordinates) ? locations[0]?.coordinates[1] : ""
  
  if (latitude.length > 0  && longitude.length > 0 ) {
    map.setCenter({ lat: latitude, lng:  longitude })
  } 

  const image =
  "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png";
    
  var marker, i;

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
        console.log("Browser doesn't support Geolocation");
      }
    );
  }

  for (i = 0; i < locations.length; i++) {

    const infowindow = new google.maps.InfoWindow({
      content: "<div class='container' style='max-width: 240px;'>" + "<div class='row'>"
      + "<div class='col-sm-3'><img style='max-width: 50px;' src='"+ locations[i].photo +"'></div>"
      + "<div class='col-sm-9'><p>Hola Soy, " + locations[i].name + "</p><p>Call me: " + "<a href=tel:"+locations[i].phone+">" + locations[i].phone + "</a></p></div>" 
      + "</div></div>",
    });

    if(locations[i].coordinates) {
      console.log(locations);
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i]?.coordinates[0], locations[i]?.coordinates[1]),
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
}