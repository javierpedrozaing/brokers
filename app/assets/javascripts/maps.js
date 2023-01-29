// This example adds a marker to indicate the position of Bondi Beach in Sydney,
// Australia.
function initMap() {
  
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 12,
    center: { lat: -33.92, lng:  151.25 },
  });

  const contentString =
    '<div id="content">' +
    '<div id="siteNotice">' +
    "</div>" +
    '<h1 id="firstHeading" class="firstHeading">Ricardo</h1>' +
    '<div id="bodyContent">' +
    "<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large " +
    "sandstone rock formation in the southern part of the " +
    "Heritage Site.</p>" +
    '<p>Contactar <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">' +
    "https://en.wikipedia.org/w/index.php?title=Uluru</a> " +
    "(last visited June 22, 2009).</p>" +
    "</div>" +
    "</div>";
  const infowindow = new google.maps.InfoWindow({
    content: contentString,
    ariaLabel: "Broker A",
  });

  const image =
    "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png";
      
    var locations = [
      ['Bondi Beach', -33.890542, 151.274856, 4],
      ['Coogee Beach', -33.923036, 151.259052, 5],
      ['Cronulla Beach', -34.028249, 151.157507, 3],
      ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
      ['Maroubra Beach', -33.950198, 151.259302, 1]
    ];

    var marker, i;
    
    for (i = 0; i < locations.length; i++) {
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
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

window.initMap = initMap;

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