class PagesController < ApplicationController
  include PagesHelper

  def home
    if user_signed_in? && current_user.member_since.nil?
      redirect_to profile_index_path, id_user: current_user.id
    end    
  end

  def get_brokers_locations
    geocoder = Geocoder
    brokers = Broker.all.where.not(id: 0)
    brokers_coordinates = brokers.map do |br|
      country = get_country(br.country) unless br.country.empty?      
      country_name = country ? JSON.parse(country.body)["name"] : ''
      state = get_state(country_name, br.try(:state))
      state_name = state['name']
      address = br.address
      location = "#{address}, #{country_name}, #{state_name}"
      full_address = location.strip.length > 3 ? location : ''
      photo = br.user.photo.attached? ? url_for(br.user.photo) : ''
      {
        broker_id: br.id,
        name: "#{br.user.first_name} #{br.user.last_name}",
        city: br.city,
        photo: photo,
        phone: br.user.phone,
        coordinates: geocoder.coordinates(full_address)
      }
    end

    if brokers_coordinates
      brokers_coordinates.compact! 
      render json: brokers_coordinates.to_json
    else 
      render json: ""
    end

  end

  def search_brokers
    @countries = countries_list
    unless request.method == 'GET'
      location = JSON.parse(params.keys.first)['location']
      address = ""
      address << location['country'].to_s << " " << location['state'].to_s << " " << location['city'].to_s
      locations = Geocoder.search(address)
      render json: locations.first.coordinates.to_json
    end
  end

  def get_states_by_country    
    states_by_country(params[:country_id])
  end

  def get_cities_by_country_and_state
    cities_by_country_and_state(params[:country], params[:state_id])
  end

  private  
end
