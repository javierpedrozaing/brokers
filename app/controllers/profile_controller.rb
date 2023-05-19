class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(current_user.id)
    @agent = Agent.find_by_user_id(current_user.id) || Agent.new
    @broker = Broker.find_by_user_id(current_user.id) || Broker.new
    @current_country = current_user.role.downcase == 'broker' ? @broker&.country : @agent&.country
    @current_state = current_user.role.downcase == 'broker' ? @broker&.state : @agent&.state
    @current_city = current_user.role.downcase == 'broker' ? @broker&.city : @agent&.city
    @countries, @states, @cities = get_countries_states_and_cities
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


  def update_profile
    @user = User.find(current_user.id)
    @user.photo.attach(params[:photo]) if params[:photo]
    @user.member_since = DateTime.now
    @user.member_end = DateTime.now.next_year(1).to_time
    @user.update!(permit_params_user)
    @countries, @states, @cities = get_countries_states_and_cities
    if @user.role.downcase == 'broker'      
      current_broker = Broker.find_by_user_id(@user.id)      
      @broker = current_broker.nil? ? Broker.create(permit_params_broker) : update_brokers_params(current_broker)
    elsif
      current_agent = Agent.find_by_user_id(@user.id)
      @agent = current_agent.nil? ? Agent.create(permit_params_agent) : update_agents_params(current_agent)          
    end

    if (@user.save && @broker && @broker.valid?) || (@user.save && @agent)
      redirect_to '/', notice: "Profile successfully updated" 
    else
      render :index
    end   
  end

  def view_profile
    @broker = Broker.find(params[:id])
  end

  def update_agents_params agent
    agent.update!(permit_params_agent)
  end

  def update_brokers_params broker
    broker.update(permit_params_broker)
    broker
  end

  private

  def permit_params_user
    params.permit(:first_name, :last_name, :phone, :email, :user_state)
  end

  def permit_params_broker
    params.permit(
      :company_name, 
      :company_licence, 
      :years_in_bussiness, 
      :insurance_carrier, 
      :insurance_policy, 
      :licence, 
      :licencia_expiration_date,
      :reserver_zip_code,
      :birthday,
      :address,
      :country,
      :city,
      :state,
      :director,
      :user_id
    )
  end

  def permit_params_agent
    params.permit(:birthday, :address, :country, :city, :state, :zip_code, :user_id)
  end

  def site_parms
    params.permit(:utf8, :authenticity_token)
  end
end
