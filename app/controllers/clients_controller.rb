class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_role_user
  before_action :validate_email_registered, only: [:create]
  before_action :has_valid_profile

  # Section list clients for brokers and agents
  def index
    #@clients = Client.all
    @title = current_user.role.downcase == "broker" ? "Broker Clients" : "Agents Clients"
    @clients, @inbound_referidos, @outbound_referidos = get_clients_by(@role_user)    
  end

  def new
    @user = User.new
    @client = Client.new
    select_referreds_by(@role_user)
  end

  def show
    @user = User.find(params[:user_id])
  end

  def edit
    user_id = params[:user_id]
    client = User.find(user_id).client
    client.user.first_name = params[:first_name] if params[:first_name]
    client.user.last_name = params[:last_name] if params[:last_name]
    client.user.phone = params[:phone] if params[:phone]
    client.user.email = params[:email] if params[:email]
    client.user.user_state = params[:user_state] if params[:user_state]
    
    if client.save!
      redirect_to show_client_path(user_id), flash: {notice: "Client successfully updated"}
    else
      render :edit
    end
  end

  def create
    select_referreds_by(@role_user)
    @user = User.new(permit_params_user)
    if @user.save!
      client = Client.new
      client.user_id = @user.id      
      if current_user.role.downcase == 'broker'
        client.agent_id = 0
        client.broker_id = current_user.broker.id
      else        
        client.agent_id = current_user.agent.id
        client.broker_id = 0
      end
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

  def create_referral #for refer agent and brokers
    client = Client.find(params[:client_id])
    # for the agent_id, if the role is broker would take the agent selected in the form, otherwise would be the current agent
    agent_id = current_user.role.downcase == 'broker' ? params[:client][:agent_id].to_i : current_user.agent.id
    client.agent_id = agent_id
    # if role user is agent, the broker_id would be the agent's broker
    broker_id = current_user.role.downcase == 'agent' ? params[:client][:broker_id].to_i : current_user.broker.id
    client.broker_id = broker_id
    
    client.type_of_house = params[:type_of_house] if  params[:type_of_house]
    client.number_of_rooms = params[:number_of_rooms] if params[:number_of_rooms]
    client.parkng_lot = params[:parkng_lot] if params[:parkng_lot]
    client.budget = params[:budget] if params[:budget]    
    if client.save!    
      create_transaction(params, client)
      flash[:success] = "Refered created succesfully"
      redirect_to clients_path
    else
      render :refer_agent
    end
  end

  def create_transaction(params, client)
    if current_user.role.downcase == 'agent'
      origin_agent = current_user.agent.id
      destination_broker = params[:client][:broker_id]
    end

    if current_user.role.downcase == 'broker'
      origin_broker = current_user.broker.id
      assigned_agent = params[:client][:agent_id]
    end

    transaction_params = {
      origin_broker: origin_broker,
      destination_broker: destination_broker,
      origin_agent: origin_agent,
      assigned_agent: assigned_agent,
      client_id: client.id
    }
    transaction = Transaction.create(transaction_params)
    
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
      return unless broker
      unassing_clients = Client.where(broker_id: broker.id, agent_id: 0)
      inbound_clients =Client.where(broker_id: broker.id).joins(:transactions).where('transactions.destination_broker = ?', broker.id)
      outbound_clients = Client.joins(:transactions).where('transactions.origin_broker = ?', broker.id)
    else      
      agent = User.find(current_user.id).agent
      unassing_clients = Client.where(agent_id: agent.id, broker_id: 0)
      inbound_clients = Client.where(agent_id: agent.id).joins(:transactions).where('transactions.assigned_agent = ?', agent.id)
      outbound_clients = Client.joins(:transactions).where('transactions.origin_agent= ?', agent.id)
    end
    [unassing_clients, inbound_clients, outbound_clients]
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

  def has_valid_profile
    valid = false    
    user = User.find(current_user.id)
    if current_user.role.downcase == 'broker'
      valid = user.broker      
    else
      valid = user.agent
    end    
    redirect_to profile_index_path, flash: {notice: "Please complete your profile"} unless valid
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