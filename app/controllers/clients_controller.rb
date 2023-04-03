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
    @user_states = ApplicationHelper::USER_STATES
    @user = User.find(params[:user_id])
    client_id = @user.client.id
    @client = Client.find(client_id)
    transaction = Transaction.find_by_client_id(client_id)    
    @pdf_attached = transaction.proof_check if transaction
  end

  def edit
    user_id = params[:user_id]
    user = User.find(user_id)
    transaction = Transaction.find_by_client_id(params[:client_id])    
    transaction.proof_check.attach(params[:proof_check]) if params[:proof_check]
    transaction.contract_price = params[:full_sale]
    transaction.close_date = DateTime.now.to_time
    transaction.commission = params[:commission]
    user.user_state =  params[:user_state]
    
    if user.update!(permit_params_user) && transaction.save
      redirect_to show_client_path(user_id), flash: {notice: "Client successfully updated"}
    else
      render :edit
    end
  end

  def create    
    select_referreds_by(@role_user)
    @user = User.new(permit_params_user)
    if @user.save
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

      flash[:success] = "Client was successfully created."
      redirect_to clients_path
    else
      render :new
    end
  end

  def refer_broker
    select_referreds_by(@role_user)
    @user = User.find(params[:user_id])
    @brokers = Broker.all
    @client = Client.find_by_user_id(@user.id)
    common_refer_attributes(@client)
  end

  def refer_agent
    select_referreds_by(@role_user)
    @user = User.find(params[:user_id])
    @client = Client.find_by_user_id(@user.id)
    @brokers = Broker.all
    common_refer_attributes(@client)
  end

  def create_referral #for refer agents and brokers
    client = Client.find(params[:client_id])
    user = User.find(client.user_id)
    user.notes = params[:notes]
    # for the agent_id, if the role is broker would take the agent selected in the form, otherwise would be the current agent
    agent_id = current_user.role.downcase == 'broker' ? params[:client][:agent_id].to_i : current_user.agent.id
    client.agent_id = agent_id
    
    # if role user is agent, the broker_id would be the agent's broker
    broker_id = current_user.role.downcase == 'agent' ? params[:client][:broker_id].to_i : current_user.broker.id
    client.broker_id = broker_id
    
    client.type_of_property = params[:type_of_property] if  params[:type_of_property]
    client.number_of_rooms = params[:number_of_rooms] if params[:number_of_rooms]
    client.number_of_bathrooms = params[:number_of_bathrooms] if params[:number_of_bathrooms]
    client.parkng_lot = params[:parkng_lot] if params[:parkng_lot]
    client.budget = params[:budget] if params[:budget]

    if client.save! && user.save!
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
      destination_broker = 0
      origin_broker = current_user.broker.id
      assigned_agent = params[:client][:agent_id]
    end

    transaction_params = {
      origin_broker: origin_broker,
      destination_broker: destination_broker,
      origin_agent: origin_agent,
      assigned_agent: assigned_agent,
      client_id: client.id,                        
      property_address: params[:property_address],
    }
    transaction = Transaction.create(transaction_params)    
    # create a transaction history and calculate fee or commission
  end

  def assign_broker
    @user = User.find(params[:user_id])
    @client = Client.find_by_user_id(@user.id)
    @brokers = Broker.all
  end

  def change_broker
    client = Client.find(params[:client_id])
    client.broker_id = params[:client][:broker_id]
    transaction = Transaction.find_by_client_id(params[:client_id])
    transaction.origin_broker = current_user.broker.id
    transaction.destination_broker = params[:client][:broker_id]
    if transaction.save! && client.save!
      flash[:success] = "Refered created succesfully"
      redirect_to clients_path
    else
      render :assign_broker
    end
  end

  private

  def common_refer_attributes(client)
    @properties = ApplicationHelper::PROPERTIES
    @number_of_rooms = ApplicationHelper::ROOMS
    @parking_lots = ApplicationHelper::PARKING_LOTS
    @bathrooms = ApplicationHelper::BATHROOMS

    @current_type_of_property = client.type_of_property
    @current_number_of_rooms = client.number_of_rooms
    @current_parking_lot = client.parkng_lot
    @current_number_of_bathrooms = client.number_of_bathrooms  
  end

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
      own_clients = Client.where(broker_id: broker.id, agent_id: 0)
      unassing_clients_refered = Client.joins(:transactions).where('transactions.destination_broker = ?', broker.id)      
      unassing_clients = unassing_clients_refered.empty? ? own_clients : own_clients + unassing_clients_refered

      inbound_clients = Client.where(broker_id: broker.id).joins(:transactions).where(['transactions.origin_broker = ? and transactions.destination_broker != ?', broker.id,  broker.id])
      outbound_clients = Client.where('broker_id != ?', broker.id).joins(:transactions).where('transactions.origin_broker = ?', broker.id)
    else
      agent = User.find(current_user.id).agent
      unassing_clients = Client.where(agent_id: agent.id, broker_id: 0)
      inbound_clients = Client.where(agent_id: agent.id).joins(:transactions).where('transactions.assigned_agent = ?', agent.id)
      outbound_clients = Client.where(agent_id: agent.id).joins(:transactions).where('transactions.origin_agent= ?', agent.id)
    end
    [unassing_clients.uniq, inbound_clients.uniq, outbound_clients.uniq]
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
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation, :notes, :user_state, :commission, :full_sale)
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

  def permit_params_client
    params.permit(:agent_id, :broker_id, :type_of_property, :number_of_rooms, :parkng_lot, :budget)
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