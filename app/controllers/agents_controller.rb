class AgentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @agents = Agent.where(broker_id: current_user.id)
  end

  def new
    @user = User.new    
  end

  def create
    user = User.create(permit_params_user)
    byebug
    if user
      agent = Agent.new
      agent.user_id = user.id
      agent.broker_id = current_user.id
      agent.save!
    end

    if user && agent      
      flash[:success] = "Agent created"
      redirect_to agents_path
    else
      flash[:error] = "Error"
      render :new
    end
  end

  def assign_client

  end

  private 
  
  def permit_params_user
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation)
  end

end