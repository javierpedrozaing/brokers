
$(document).on('turbolinks:load', function(){

  current_country = $('#country').val();
  current_state = $('#state').val();
  getCitiesByCountryandState(current_country, current_state);    

  $('#country').change(function(){    
    console.log("country => ", $( this ).val())
    getStatesByCountry($( this ).val()); // val => ISO2 Code of Country    
  });
    
  $('#state').change(function(){
    $('#city').empty();
    console.log("state => ", $( this ).val());
    getCitiesByCountryandState(current_country, $( this ).val());            
  });

  function getStatesByCountry(country) {
    Rails.ajax({
      type: 'POST',
      url: '/get_states_by_country/' + country,
      success: function(data) {
        if(data.states.length > 0) {
          $('#state').empty();
          states = data.states.map(state => [state.name, state.iso2]);              
          states.forEach((state, index) => {            
            $('#state').append(new Option(state[0], state[1]));
          });
          $('#state').change(function(){
            $('#city').empty();
            console.log("state => ", $( this ).val());
            getCitiesByCountryandState(country, $( this ).val());            
          });
        }
      },
      error: function(data) {
        console.error(data);
      }
    })
  };

  function getCitiesByCountryandState(country, state_id) {    
    Rails.ajax({
      url: '/get_cities_by_country_and_state/' + country + '/' + state_id,
      type: 'POST',
      success: function(data) {
        $('#city').empty();
        if(data.cities.length > 0) {
          cities = data.cities.map(city => [city.name, city.id]);     
          if ( cities.length > 0) {
            cities.forEach(city => {
              $('#city').append(new Option(city[0], city[1]));
            });
          }
        }
      },
      error: function(data) {
        console.error(data);
      }
    })
  };
});