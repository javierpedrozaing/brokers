class AgentsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_email_registered, only: [:create]
  before_action :get_clients, only: [:assign_client]

  def index
    @agents = Agent.where(broker_id: current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(permit_params_user)
    if @user.save
      agent = Agent.new
      agent.user_id = @user.id
      agent.broker_id = current_user.id    

      respond_to do |format|
        if agent.save
           format.html { redirect_to @user, notice: 'Agent was successfully created.' }
           format.json { render :new, status: :created, location: @recipe }
        else
          flash[:error] = "Error creating Agent. try agian"
          redirect_to new_agent_path
        end
     end
    else
      render :new
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
  
  def permit_params_user
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation)
  end

end