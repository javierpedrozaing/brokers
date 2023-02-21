class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_role_user
  before_action :validate_email_registered, only: [:create]

  # Section list clients for brokers and agents
  def index
    #@clients = Client.all
    @clients, @referidos = get_clients_by(@role_user)
  end

  def new
    @user = User.new
    @client = Client.new
    select_referreds_by(@role_user)
  end

  def create
    select_referreds_by(@role_user)
    @user = User.new(permit_params_user)
    if @user.save
      client = Client.new
      client.user_id = @user.id
      client.agent_id = params[:client][:agent_id]
      client.save!
    end

    if @user && client
      flash[:success] = "Client was successfully created."
      redirect_to clients_path
    else
      render :new
    end
  end

  def refer_broker
    select_referreds_by(@role_user)
    @user = User.find(params[:user_id])
    @client = Client.find_by_user_id(@user.id)
    @brokers = Broker.all
  end

  def refer_agent
    select_referreds_by(@role_user)
    @user = User.find(params[:user_id])
    @client = Client.find_by_user_id(@user.id)
    @brokers = Broker.all
  end

  def create_referral
    client = Client.find(params[:client_id])
    # for the agent_id, if the role is broker would take the agent selected in the form, otherwise would be the current agent
    client.agent_id = current_user.role == 'broker' ? params[:client][:agent_id] : current_user.agent.id
    # if role user is agent, the broker_id would be the agent's broker    
    client.broker_id = current_user.role.downcase == 'agent' ? params[:client][:broker_id] : current_user.id
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

  def get_role_user
    @role_user = current_user.role
  end

  def validate_email_registered
    unless params[:email].empty?
      user = User.find_by_email(params[:email])
      if user
        flash[:error] = "Error creating User, email is already registered"
        redirect_to new_client_path
      end      
    end
  end

  def get_clients_by(role_user)
    if role_user.downcase == 'broker'
      broker = User.find(current_user.id).broker
      clients = Client.where(agent_id: broker.agents.ids)
      referidos = Client.where(broker_id: broker.id)
    else
      agent = User.find(current_user.id).agent
      clients = Client.where(agent_id: agent.id)
      referidos = Client.where(agent_id: agent.id).where(broker_id: agent.broker.id)
    end
    [clients, referidos]
  end

  def select_referreds_by(role_user)
    if role_user.downcase == 'broker'
      @referreds = User.find(current_user.id).broker.agents
    else
      @referreds = [User.find(current_user.id).agent]
    end
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