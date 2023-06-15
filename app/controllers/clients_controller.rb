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
    @transaction = Transaction.find_by_client_id(client_id)
    @pdf_attached = @transaction.proof_check if @transaction
  end

  def edit
    @user_states = ApplicationHelper::USER_STATES
    @user = User.find(params[:user_id])
    client_id = @user.client.id
    @client = Client.find(client_id)
    @transaction = Transaction.find_by_client_id(client_id)
    @pdf_attached = @transaction.proof_check if @transaction
  end

  def update_client
    user_id = params[:user_id]
    user = User.find(user_id)
    transaction = Transaction.find_by_client_id(params[:client_id])    
    transaction.proof_check.attach(params[:proof_check]) if params[:proof_check]
    transaction.contract_price = params[:full_sale]
    transaction.close_date = DateTime.now.to_time
    transaction.commission = params[:commission]
    user.user_state =  params[:user_state]
    
    if user.update!(permit_params_user) && transaction.save
      UserMailer.client_updated_status(current_user, params[:client_id]).deliver_now
      redirect_to show_client_path(user_id), flash: {notice: "Client successfully updated"}
    else
      render :edit
    end
  end

  def create_client
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

  def refer_client_from_broker
    @brokers = Broker.all
    default_values_for_create_referreds
    @price_range_group_a =  [
      [0, 100000],
      [100000, 200000],
      [200000, 300000],
      [300000, 400000],
      [400000, 500000],
      [500000, 600000],
      [600000, 700000],
      [700000, 800000],
      [800000, 900000],
      [900000, 1000000]                    
    ]

    @price_range_group_b = price_range_group_b
    @client = params.include?(:email) ? create_client_from_broker : nil        

    unless @client.nil?
      @user = User.find(@client.user_id)
      @user.notes = params[:notes]
      @client.broker_id = params[:client][:broker_id].to_i
      @client.type_of_property = params[:type_of_property] if  params[:type_of_property]
      @client.number_of_rooms = params[:number_of_rooms] if params[:number_of_rooms]
      @client.number_of_bathrooms = params[:number_of_bathrooms] if params[:number_of_bathrooms]
      @client.parkng_lot = params[:parkng_lot] if params[:parkng_lot]
      @client.budget = params[:budget] if params[:budget]
  
      if @client.save && @user.save
        create_transaction_from_broker(params, @client)
        flash[:success] = "Refered created succesfully"
        redirect_to clients_path
      else
        render :refer_client_from_broker
      end
    end
  end

  def create_client_from_broker
    user = User.new(permit_params_user)
    user.with_lock do
      if user.save
        client = Client.new
        client.user_id = user.id
        client.agent_id = 0
        client.broker_id = current_user.broker.id
        client.save!
        client
      end
      #todo add validation to render with message errros
    end
  end

  def create_transaction_from_broker(params, client)
    origin_broker = current_user.broker.id
    @referral = Broker.find(origin_broker)
    destination_broker = params[:client][:broker_id]
    
    transaction_params = {
      origin_broker: origin_broker,
      destination_broker: destination_broker,
      client_id: client.id,
      property_address: params[:property_address],
    }
    
    current_transaction = Transaction.find_by_client_id(client.id)
    
    if current_transaction
      current_transaction.origin_broker = origin_broker
      current_transaction.destination_broker = destination_broker
      current_transaction.property_address = params[:property_address]
      current_transaction.save!
    else
      transaction = Transaction.create(transaction_params)
    end

    self.send_confirm_referred_email(origin_broker, destination_broker, client.id)
  end

  def create_referral #for refer agents and brokers
    client = Client.find(params[:client_id])
    user = User.find(client.user_id)
    user.notes = params[:notes]
    # for the agent_id, if the role is broker would take the agent selected in the form, otherwise would be the current agent
    # agent_id = current_user.role.downcase == 'broker' ? params[:client][:agent_id].to_i : current_user.agent.id
    # client.agent_id = agent_id
    
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
      @referral = Agent.find(origin_agent)
      destination_broker = params[:client][:broker_id]
      origin_broker = Agent.find(origin_agent).broker_id # clean origin broker, for refereds to external broker from agent
    end

    if current_user.role.downcase == 'broker'
      origin_broker = current_user.broker.id
      @referral = Broker.find(origin_broker)
      assigned_agent = params[:client][:agent_id]
      client = Client.find(client.id)
      client.agent_id = assigned_agent
      client.save!
      destination_broker = assigned_agent.to_i > 0 ? 0 : current_user.broker.id
    end

    transaction_params = {
      origin_broker: origin_broker,
      destination_broker: destination_broker,
      origin_agent: origin_agent,
      assigned_agent: assigned_agent,
      client_id: client.id,                        
      property_address: params[:property_address],
    }
    
    current_transaction = Transaction.find_by_client_id(client.id)
    
    if current_transaction
      current_transaction.origin_broker = origin_broker
      current_transaction.destination_broker = destination_broker
      current_transaction.origin_agent = origin_agent || 0
      current_transaction.assigned_agent = assigned_agent
      current_transaction.property_address = params[:property_address]
      current_transaction.save!
    else
      transaction = Transaction.create(transaction_params)
    end

    self.send_confirm_referred_email(origin_agent || origin_broker, destination_broker, client.id)
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
    default_values_for_create_referreds

    unless client
      @current_type_of_property = client&.type_of_property
      @current_number_of_rooms = client&.number_of_rooms
      @current_parking_lot = client&.parkng_lot
      @current_number_of_bathrooms = client&.number_of_bathrooms  
    end    
  end

  def default_values_for_create_referreds
    @properties = ApplicationHelper::PROPERTIES
    @number_of_rooms = ApplicationHelper::ROOMS
    @parking_lots = ApplicationHelper::PARKING_LOTS
    @bathrooms = ApplicationHelper::BATHROOMS
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
      agents_broker_id = broker.agents.map{|ag| ag.id}
      clients_from_agents = Client.where(agent_id: agents_broker_id).includes(:transactions).where(transactions: { id: nil })
      unassing_clients = own_clients + clients_from_agents

      inbound_clients_default_assigned = Client.where(broker_id: 0)
      inbound_clients = Client.where(broker_id: broker.id).joins(:transactions).where(['transactions.origin_broker = ? and transactions.destination_broker != ?', broker.id,  broker.id])
      clients_refered_from_agents = Client.joins(:transactions).where('transactions.destination_broker = ?', broker.id)
      inbound_clients += inbound_clients_default_assigned
      
      outbound_clients = Client.where('broker_id != ?', broker.id).joins(:transactions).where('transactions.origin_broker = ? and transactions.destination_broker > ?', broker.id, 0)
      outbound_clients_of_agent = Client.where(broker_id: broker.id).joins(:transactions).where('transactions.destination_broker != ?', broker.id)
      outbound_clients
    else
      agent = User.find(current_user.id).agent
      unassing_clients = Client.where(agent_id: agent.id, broker_id: 0).includes(:transactions).where(transactions: { id: nil })
      inbound_clients = Client.joins(:transactions).where('transactions.assigned_agent = ?', agent.id)
      outbound_clients = Client.where(agent_id: agent.id).joins(:transactions).where('transactions.destination_broker != ?', 0)
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

  def send_confirm_referred_email(sender, destination, client)
    # the destination user always gonna be a borker user
    broker = Broker.find(destination)
    user_sender = current_user.role.downcase == 'agent' ? Agent.find(sender) : Broker.find(sender)
    UserMailer.client_referred_email(user_sender, broker, client).deliver_now
  end

  def price_range_group_b
    start_price = 1_000_000
    end_price = 50_000_000
    interval = 500_000

    price_ranges = []
    while start_price <= end_price
      price_ranges << [start_price, start_price + 1_500_000]
      start_price += interval
    end
    price_ranges
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