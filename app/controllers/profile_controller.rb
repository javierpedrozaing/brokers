class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(current_user.id)
    @agent = Agent.find_by_user_id(current_user.id) || Agent.new
    @broker = Broker.find_by_user_id(current_user.id) || Broker.new
    @current_country = current_user.role.downcase == 'broker' ? @broker&.country : @agent&.country
    @current_state = current_user.role.downcase == 'broker' ? @broker.state : @agent.state
    @current_city = current_user.role.downcase == 'broker' ? @broker.city : @agent.city    
    @countries = countries_list.map{|c| [c['name'], c['iso2']]} unless countries_list.empty?
    @states = @current_country ? states_list_by_country(@current_country).map{|c| [c['name'], c['iso2']]} : []
    @cities = @current_country ? cities_list(@current_country).map{|c| [c['name'], c['id']]} : []
  end

  def update_profile
    user = User.find(current_user.id)
    byebug
    user.photo.attach(params[:photo]) if params[:photo]
    user.member_since = DateTime.now
    user.member_end = DateTime.now.next_year(1).to_time
    user.update!(permit_params_user)
    if user.role.downcase == 'broker'
      broker_exist = Broker.find_by_user_id(user.id)
      @broker = broker_exist.nil? ? Broker.create(permit_params_broker) : update_brokers_params(broker_exist)            
    elsif
      agent_exist = Agent.find_by_user_id(user.id)
      @agent = agent_exist.nil? ? Agent.create(permit_params_agent) : update_agents_params(agent_exist)          
    end

    if user.save && (@broker || @agent)
      redirect_to "/", flash: {notice: "Profile successfully updated"}
    elsif
      redirect_to profile_index_path, flash: {alert: "Something was wrong, try again"}
    end
  end

  def update_agents_params agent
    agent.update!(permit_params_agent)
  end

  def update_brokers_params broker
    broker.update!(permit_params_broker)
  end

  private

  def permit_params_user
    params.permit(:first_name, :last_name, :phone, :email)
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
