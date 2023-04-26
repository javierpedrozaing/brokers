
$(document).on('turbolinks:load', function(){
    $('#country').data("country_name", $('#country').val());
    $('#state').data("state_name", $('#state').val());
    $('#city').data("city_name", $('#city').val());    
    current_country = $('#country').data('country_name');
    current_state = $('#state').data('state_name');    
    // if(current_country.length > 0 && current_state.length > 0) {
    //   getCitiesByCountryandState(current_country, current_state);
    // }
  $('#country').change(function(){
    console.log("country => ", $( this ).val())
    $('#country').data("country_name", $(this).text().toLowerCase());
    getStatesByCountry($( this ).val()); // val => ISO2 Code of Country    
  });
    
  $('#state').change(function(){
    current_country = $('#country').val();
    $('#city').empty();
    $('#state').data("state_name", $(this).text().toLowerCase());
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
          $('#state').attr("with","300");
          
          $('#state').change(function(){
            $('#city').empty();
            $('#city').data("city_name", $(this).text().toLowerCase());           
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
        if(data.cities.length > 0) {
          $('#city').empty();
          cities = data.cities.map(city => [city.name, city.id]);     
          if ( cities.length > 0) {
            cities.forEach(city => {
              $('#city').append(new Option(city[0], city[0].toLowerCase()));
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