class PagesController < ApplicationController
  include PagesHelper

  def home
    if user_signed_in? && current_user.member_since.nil?
      redirect_to profile_index_path, id_user: current_user.id
    elsif user_signed_in? && current_user.role == 'broker'
      redirect_to home_brokers_path
    elsif user_signed_in? && current_user.role == 'agent'
      redirect_to home_agents_path
    end
  end

  def home_brokers
    @total_countries = 250
    @total_brokers = Broker.all.count
    @total_closed_transactions = Transaction.where.not(close_date: nil).count
    @total_sales = User.pluck(:full_sale).sum(&:to_f)

    @total_outbound = Transaction.where("origin_broker = ? and assigned_agent > ?", current_user.id, 0).count
    @total_inbound = Transaction.where("destination_broker = ?", current_user.id).count
    @showing = Broker.find_by_user_id(current_user.id).clients.map{|client| client.user.user_state == 'showing_property'}.count
    @in_progress = Broker.find_by_user_id(current_user.id).clients.map{|client| client.user.user_state == 'active' || client.user.user_state == 'transaction_processing' || client.user.user_state == 'making_offer' }.count
    @closed = Transaction.where(origin_broker: current_user.id).where.not(close_date: nil).count
  end

  def home_agents
    @total_countries = 250
    @total_brokers = Broker.all.count
    @total_closed_transactions = Transaction.where.not(close_date: nil).count
    @total_sales = User.pluck(:full_sale).sum(&:to_f)

    @total_outbound = Transaction.where("origin_agent = ? and assigned_agent > ?", current_user.id, 0).count
    @total_inbound = Transaction.where("assigned_agent = ?", current_user.id).count
    @showing = Agent.find_by_user_id(current_user.id).clients.map{|client| client.user.user_state == 'showing_property'}.count
    @in_progress = Agent.find_by_user_id(current_user.id).clients.map{|client| client.user.user_state == 'active' || client.user.user_state == 'transaction_processing' || client.user.user_state == 'making_offer' }.count
    @closed = Transaction.where(origin_agent: current_user.id).where.not(close_date: nil).count
  end

  def home_brokers

  end

  def home_agents
    
  end

  def home_brokers

  end

  def home_agents
    
  end

  def get_brokers_locations
    geocoder = Geocoder
    brokers = Broker.all.where.not(id: 0)
    brokers_coordinates = brokers.map do |br|
      country = ApplicationController::get_country(br.country) unless br.country.empty?      
      country_name = country ? JSON.parse(country.body)["name"] : ''
      state = ApplicationController::get_state(country_name, br.try(:state))
      state_name = state['name']
      city =  br&.city.capitalize()
      address = br.address
      location = "#{country_name}, #{state_name}, #{city}, #{address}"
      full_address = location.strip.length > 3 ? location : ''
      photo = br.user.photo.attached? ? url_for(br.user.photo) : ActionController::Base.helpers.image_path('profile.png')
      {
        broker_id: br.id,
        name: "#{br.user.first_name} #{br.user.last_name}",
        city: br.city,
        photo: photo,
        phone: br.user.phone,
        email: br.user.email,
        company: br.company_name,
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
    @countries, @states, @cities = get_countries_states_and_cities    

    @brokers = Broker.all.reject{|br| br.user.role.downcase == 'admin'}

    unless request.method == 'GET'
      location = JSON.parse(params.keys.first)['location'] if params.keys.first
      address = ""
      @country = location['country'].to_s 
      @state = location['state'].to_s
      @city = location['city'].to_s
      address << @country << " " << @state << " " << @city
      locations = Geocoder.search(address)
      with_country = @country.nil? || @country.empty? ? '' : "brokers.country = ? and"
      with_state = @state.nil? || @state.empty? ? '' : "brokers.state = ? and"
      with_city =  @city.nil? || @city.empty? ? '' : "brokers.city = ? " 
      query_location = "#{with_country} #{with_state} #{with_city}"        
      @brokers = Broker.where(query_location, @country, @state, @city)
      users = @brokers.map{|br| {full_name: br.user.full_name, email: br.user.email, phone: br.user.phone, id: br.id}}      
      render json: {coordinates: locations.first.coordinates, brokers: users }
    end        
  end

  def get_countries_states_and_cities
    @current_country = current_user.role.downcase == 'broker' ? @broker&.country : @agent&.country
    @countries = ApplicationController::countries_list.map{|c| [c['name'], c['iso2']]} unless ApplicationController::countries_list.nil? || ApplicationController::countries_list.empty?
    states_list = ApplicationController::states_list_by_country(@current_country) unless @current_country.nil?    
    @states = states_list.nil? || states_list.length <= 1 ? [] : states_list.map{|c| [c['name'], c['iso2']]}
    cities_list = ApplicationController::cities_list(@current_country) unless @current_country.nil?
    @cities = cities_list.nil? || states_list.length <= 1 ? [] : cities_list.map{|c| [c['name'], c['name'].downcase]}
    [@countries, @states, @cities]
  end    

  def get_states_by_country
    states = ApplicationController::states_by_country(params[:country_id])
    render json: {states: states}
  end

  def get_cities_by_country_and_state
    cities = ApplicationController::cities_by_country_and_state(params[:country], params[:state_id])
    render json: {cities: cities}
  end

  private  
end
