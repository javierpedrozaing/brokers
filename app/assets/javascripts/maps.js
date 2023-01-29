// This example adds a marker to indicate the position of Bondi Beach in Sydney,
// Australia.

$(document).ready(function() {
  getLocations();

  function getLocations() {
    Rails.ajax({
      url: "/brokers_locations",
      type: "get",
      success: function(data) {     
        debugger   
        initMap(data)
      },
      error: function(data) {
        console.error(data);
      }
    })
  }
});


function initMap(locations) {
  
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 12,
    center: { lat: locations[0].coordinates[0], lng: locations[0].coordinates[1] },
  });

  const contentString = "";
 
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

window.initMap = initMap();

// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
// function initMap() {
//   const map = new google.maps.Map(document.getElementById("map"), {
//     center:  { lat: 41.85, lng: -87.65 },
//     zoom: 15,
//   });
//   const request = {
//     placeId: "ChIJN1t_tDeuEmsRUsoyG83frY4",
//     fields: ["name", "formatted_address", "place_id", "geometry"],
//   };
//   const infowindow = new google.maps.InfoWindow();
//   const service = new google.maps.places.PlacesService(map);

//   service.getDetails(request, (place, status) => {

//   const image =
//     "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png";

//     if (
//       status === google.maps.places.PlacesServiceStatus.OK &&
//       place &&
//       place.geometry &&
//       place.geometry.location
//     ) {
//       const marker = new google.maps.Marker({
//         position: { lat: -41.89, lng: 151.274 },        
//         map,
//         icon: image,
//       });

//       google.maps.event.addListener(marker, "click", () => {
//         const content = document.createElement("div");
//         const nameElement = document.createElement("h2");

//         nameElement.textContent = place.name;
//         content.appendChild(nameElement);

//         const placeIdElement = document.createElement("p");

//         placeIdElement.textContent = place.place_id;
//         content.appendChild(placeIdElement);

//         const placeAddressElement = document.createElement("p");

//         placeAddressElement.textContent = place.formatted_address;
//         content.appendChild(placeAddressElement);
//         infowindow.setContent(content);
//         infowindow.open(map, marker);
//       });
//     }
//   });
// }

// window.initMap = initMap;