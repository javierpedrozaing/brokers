
$(document).on('turbolinks:load', function(){  
  $('country').change(function(){
    $( "select option:selected" ).each(function() {
      getStatesByCountry($( this ).val()); // val => ISO2 Code of Country
    });
  });

  function getStatesByCountry(country_id) {
    Rails.ajax({
      url: "/get_states_by_country",
      type: "post",
      data: {country_id: country_id},
      success: function(data) {
        states = data.map(state => state.name);      
        if ( states.length > 0) {
          states.forEach(state => {
            $('states').append(new Option(state.name, state.iso2))
          });
        }
        // [
        //   {
        //     "id": 4008,
        //     "name": "Maharashtra",
        //     "iso2": "MH"
        //   },
        //   ...
        // ]
      },
      error: function(data) {
        console.error(data);
      }
    })
  };


  function getCitiesByCountry(country_id) {
    Rails.ajax({
      url: "/get_cities_by_country",
      type: "post",
      data: {country_id: country_id},
      success: function(data) {
        cities = data.map(city => city.name);      
        if ( cities.length > 0) {
          cities.forEach(city => {
            $('cities').append(new Option(city.name, city.iso2))
          });
        }
        // [
        //   {
        //     "id": 4008,
        //     "name": "Maharashtra",
        //     "iso2": "MH"
        //   },
        //   ...
        // ]
      },
      error: function(data) {
        console.error(data);
      }
    })
  };


});