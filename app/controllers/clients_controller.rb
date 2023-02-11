class ClientsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordInvalid, with: :error_creating_user
  before_action :get_agents_by_broker_id, only: [:new, :refer_agent]
  before_action :validate_email_registered, only: [:create]

  def index
    @clients = Client.all
  end

  def new
    @user = User.new
    @client = Client.new    
  end

  def create    
    user = User.create(permit_params_user)
    if user
      client = Client.new
      client.user_id = user.id
      client.agent_id = params[:client][:agent_id]
      client.save!
    end    

    if user && client
      flash[:success] = "Client created"
      redirect_to clients_path
    else
      flash[:error] = "Error creating Client"
      redirect_to new_client_path
    end
  end

  def refer_agent
    @user = User.find(params[:user_id])
    @client = Client.find_by_user_id(@user.id)
  end

  def create_referral
    client = Client.find(params[:client_id])
    client.agent_id = params[:client][:agent_id]
    client.type_of_house = params[:type_of_house] if  params[:type_of_house]
    client.number_of_rooms = params[:number_of_rooms] if params[:number_of_rooms]
    client.parkng_lot = params[:parkng_lot] if params[:parkng_lot]
    client.budget = params[:budget] if params[:budget]
    
    if client.save!
      create_transaction(params)
      flash[:success] = "Refered created succesfully"
      redirect_to clients_path
    else
      render :refer_agent
    end
  end

  def create_transaction(params)
    # create a transaction history and calculate fee or commission
  end

  private

  def validate_email_registered
    unless params[:email].empty?
      @user = User.find_by_email(params[:email])    
      @user.errors.add(:email, :invalid, message: "Already in use") unless @user.nil?    
      flash[:error] = @user.errors.full_messages.first
      redirect_to new_agent_path    
    end    
  end

  def get_agents_by_broker_id
    @agents = Agent.where(broker_id: current_user.id)
  end
  
  def error_creating_user
    flash[:error] = "Error creating User, all fileds are required"
    redirect_to new_client_path
  end

  def permit_params_user
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation)
  end

  # def get_clients_by_agents_id
  #   Agent.where(agent_id: get_agents_id_by_broker).map do |agent|
  #     agent.clients
  #   end
  # end

  # def get_agents_id_by_broker
  #   Broker.find(current_user.id).agents.pluck(:id)
  # end
end