class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :role, :photo, :user_state])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User) && resource.role
        resource.role.downcase == 'admin' ? dashboard_path : clients_url
      else
        super
      end
  end

  def self.countries_list
    countries = HTTParty.get('https://api.countrystatecity.in/v1/countries', {
      headers: self.headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
    JSON.parse(countries.body)
  end

  def self.states_list
    states = HTTParty.get('https://api.countrystatecity.in/v1/states', {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.cities_list(country)
    cities = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/cities", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.states_list_by_country(country)
    states = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/states", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.states_by_country(country_id)
    states = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country_id}/states", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.cities_by_country_and_state(country_id, state_id)    
    cities = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country_id}/states/#{state_id}/cities", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })    
  end

  def self.get_country(country)
    country = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}", {
      headers: headers,
      debug_output: STDOUT, # To show that User-Agent is Httparty
    })
  end

  def self.get_state(country, state)
    begin
      state = HTTParty.get("https://api.countrystatecity.in/v1/countries/#{country}/states/#{state}", {
        headers: headers,
        debug_output: STDOUT, # To show that User-Agent is Httparty
      })
    rescue => exception
      puts "error connecting API with #{exception}"
      return {}
    end
  end

  def self.headers
    { 'X-CSCAPI-KEY' => ENV['KEY_COUNTRIES'] }
  end
end
