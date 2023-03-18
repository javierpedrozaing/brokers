module PagesHelper
  include HTTParty
  def countries_list
    countries = HTTParty.get('https://api.countrystatecity.in/v1/countries', {
      headers: { 'X-CSCAPI-KEY' => 'API_KEY' },
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def states_by_country(country_id)
    states = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country_id}/states", {
      headers: { 'X-CSCAPI-KEY' => 'API_KEY' },
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def cities_by_country(country_id)
    cities = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country_id}/cities", {
      headers: { 'X-CSCAPI-KEY' => 'API_KEY' },
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end


end
