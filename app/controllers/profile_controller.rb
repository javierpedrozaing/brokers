class ProfileController < ApplicationController
  before_action :get_user_role, only: :update_profile
  def index    
    @user = User.find(current_user.id)
    @agent = Agent.find_by_user_id(current_user.id)
    @broker = Broker.find_by_user_id(current_user.id)
  end

  def update_profile    
    user = User.find(current_user.id)
    user.photo.attach(params[:photo]) if params[:photo]
    user.update!(permit_params_user)
    broker = Broker.new(permit_params_broker)
    agent = Agent.new(permit_params_agent)        
   if user && broker.save! && agent.save!    
    flash.now[:notice] = "Profile updated"
   elsif 
    flash.now[:alert] = "Something was wrong, try again."
   end
  end

  def update_agents_params params

  end

  def update_brokers_params params

  end

  private

  def permit_params_user
    params.permit(:first_name, :last_name, :phone, :email, :member_since, :member_end)
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

  def get_user_role
    @role = current_user.role
  end
end
