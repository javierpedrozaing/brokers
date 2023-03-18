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
