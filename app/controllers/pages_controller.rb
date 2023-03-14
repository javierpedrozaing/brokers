class PagesController < ApplicationController
  def home
    if user_signed_in? && current_user.member_since.nil?
      redirect_to profile_index_path, id_user: current_user.id
    end    
  end

  def get_brokers_locations
    geocoder = Geocoder
    brokers = Broker.all.where.not(id: 0)
    
    brokers_coordinates = brokers.map do |br|
      photo = br.user.photo.attached? ? url_for(br.user.photo) : ''
      {   
        broker_id: br.id,
        name: "#{br.user.first_name} #{br.user.last_name}",
        city: br.city,
        photo: photo,
        phone: br.user.phone,
        coordinates: geocoder.coordinates(br.full_address)
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
    unless request.method == 'GET'
      location = JSON.parse(params.keys.first)['location']
      address = ""
      address << location['country'].to_s << " " << location['state'].to_s << " " << location['city'].to_s
      locations = Geocoder.search(address)
      render json: locations.first.coordinates.to_json
    end
  end  
end
