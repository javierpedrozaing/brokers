// This example adds a marker to indicate the position of Bondi Beach in Sydney,
// Australia.

$(document).on('turbolinks:load', function(){
  if (window.location.href.indexOf("search") > -1) {
    getSearchLocations();    
    $("#search-brokers").on('click', () => {
      let country = $("#country").val();
      let state = $("#state").val();
      let city = $("#city").val();
      
      let mydata = {location: {country: country, state: state, city: city}}
          
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
  }
  
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
          city: data.city,
          phone: data.phone
        }
      });    
      
      //window.initMap = initMap();
      if (coordinates !== undefined) {
        initSearchMap(coordinates, position);
      } else {
        initSearchMap(coordinates);
      }      
    },    
    error: function(data) {
      console.error(data);
    }
  })
};


function initSearchMap(locations, position = null) {  
  if (locations.length > 0) {
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
        content: "<div class='container' style='max-width: 240px;'>" + "<div class='row'>"
        + "<div class='col-sm-3'><img style='max-width: 50px;' src='"+ locations[i].photo +"'></div>"
        + "<div class='col-sm-9'><p>Hola Soy, " + locations[i].name + "</p><p>Call me: " + "<a href=tel:"+locations[i].phone+">" + locations[i].phone + "</a></p></div>" 
        + "</div></div>",
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
}
