class AgentsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_email_registered, only: [:create]
  before_action :get_clients, only: [:assign_client]
  before_action :has_valid_profile

  def index
    user = User.find(current_user.id)
    broker_id = user.broker.id if user.broker
    @agents = Agent.where(broker_id: broker_id)
  end

  def new
    @user = User.new
  end

  
  def show
    @user = User.find(params[:user_id])
  end

  def edit
    user_id = params[:user_id]
    agent = User.find(user_id)
    agent.first_name = params[:first_name] if params[:first_name]
    agent.last_name = params[:last_name] if params[:last_name]
    agent.phone = params[:phone] if params[:phone]
    agent.email = params[:email] if params[:email]
    agent.user_state = params[:user_state] if params[:user_state]    
    if agent.save!
      redirect_to agents_path, flash: {notice: "Agent successfully updated"}
    else
      render :edit
    end
  end

  def create
    @user = User.create(permit_params_user)
    if @user.save
      agent = Agent.new
      agent.user_id = @user.id
      agent.broker_id = User.find(current_user.id).broker.id
      
      respond_to do |format|
        if agent.save
           format.html { redirect_to agents_path, notice: 'Agent was successfully created.' }
           format.json { render :new, status: :created }
        else 
          flash[:error] = "error creating agent"
          format.html { render :new }
        end
     end
    else
      respond_to do |format|        
        format.html { render :new }
      end      
    end    
  end

  def assign_client
    @user = User.find(params[:user_id])
    @agent = Agent.find_by_user_id(@user.id)
  end
  
  def create_assignation
    agent = Agent.find(params[:agent_id])
    clients_ids = params[:agent][:client_id].reject(&:empty?)
    clients = Client.where(id: clients_ids)
    
    if clients
      clients.each do |client|
        agent.clients << client
      end
    end
    
    if agent.save!
      create_transaction(params)
      flash[:success] = "Assignation created succesfully"
      redirect_to agents_path
    else
      render :assign_client
    end
  end

  def create_transaction(params)

  end

  private
  

  def get_clients
    @clients = Client.all
  end

  def error_creating_user
    flash[:error] = "Error creating User, all fileds are required"
    redirect_to new_agent_path
  end

  def validate_email_registered
    unless params[:email].empty?
      user = User.find_by_email(params[:email])
      if user
        flash[:error] = "Error creating User, email is already registered"
        redirect_to new_agent_path
      end      
    end
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
  
  def permit_params_user
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation, :user_state)
  end

end