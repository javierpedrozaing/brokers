class ProfileController < ApplicationController  
  def index    
    @user = User.find(current_user.id)
    @agent = Agent.find_by_user_id(current_user.id) || Agent.new
    @broker = Broker.find_by_user_id(current_user.id) || Broker.new
    
  end

  def update_profile
    user = User.find(current_user.id)    
    user.photo.attach(params[:photo]) if params[:photo]
    user.member_since =  DateTime.now
    user.member_end =  DateTime.now.next_year(1).to_time
    user.update!(permit_params_user)
   if user.role == 'Broker'
    @broker = Broker.find_by_user_id(user.id)
    @broker.nil? ? Broker.new(permit_params_broker).save! : update_brokers_params(@broker)    
   elsif
    @agent = Agent.find_by_user_id(user.id)
    @agent.nil? ? Agent.new(permit_params_agent).save! : update_agents_params(@agent)    
   end

   if user && (@broker || @agent)   
    
    redirect_to "/profile/index", flash: {notice: "Profile successfully updated"}    
   elsif
    redirect_to "/profile/index", flash: {alert: "Something was wrong"}
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
      :city,
      :state,
      :director,
      :user_id
    )
  end

  def permit_params_agent
    params.permit(:birthday, :address, :city, :state, :zip_code, :user_id)
  end

  def site_parms
    params.permit(:utf8, :authenticity_token)
  end
end
