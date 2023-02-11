class PagesController < ApplicationController
  def home
    if user_signed_in? && current_user.member_since.blank?
      redirect_to profile_index_path, id_user: current_user.id
    end    
  end

  def get_brokers_locations
    geocoder = Geocoder
    brokers = Broker.all
    brokers_coordinates = brokers.map do |br|
      {   
        broker_id: br.id,
        name: "#{br.user.first_name} #{br.user.last_name}",
        city: br.city,
        photo: url_for(br.user.photo),
        coordinates: geocoder.coordinates(br.full_address)
      }
    end
    brokers_coordinates.compact! 
    render json: brokers_coordinates.to_json
  end

  def search_brokers

  end  
end
