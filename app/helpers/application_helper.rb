module ApplicationHelper
  USER_STATES = ['active', 'inactive', 'showing_property', 'making_offer', 'transaction_processing', 'close']
  ROLES = ['admin', 'broker', 'agent', 'client']
  PROPERTIES = [['House', 'house'], ['Apartamento', 'apto'], ['Local', 'local']]
  ROOMS = [['Uno', 1], ['Dos', 2], ['Tres', 3], ['Cuatro',4]]
  PARKING_LOTS = [['Uno', 1], ['Dos', 2], ['Tres', 3], ['Cuatro', 4]]
  BATHROOMS = [['Uno', 'uno'], ['Dos', 'dos'], ['Tres', 'tres'], ['Cuatro', 'cuatro']]

  def self.get_countries_states_and_cities
    @countries = ApplicationController::countries_list.map{|c| [c['name'], c['iso2']]} unless ApplicationController::countries_list.nil?
    states_list = ApplicationController::states_list_by_country(@current_country) unless @current_country.nil?    
    @states = states_list.nil? || states_list.length <= 1 ? [] : states_list.map{|c| [c['name'], c['iso2']]}
    cities_list = ApplicationController::cities_list(@current_country) unless @current_country.nil?
    @cities = cities_list.nil? || states_list.length <= 1 ? [] : cities_list.map{|c| [c['name'], c['name'].downcase]}
    [@countries, @states, @cities]
  end
end
