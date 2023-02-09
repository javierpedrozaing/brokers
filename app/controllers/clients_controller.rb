class ClientsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordInvalid, with: :error_creating_user

  def index
    @clients = Client.all
  end

  def new
    @user = User.new
    @client = Client.new
    @agents = Agent.where(broker_id: current_user.id)
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

  end

  private

  def error_creating_user
    flash[:error] = "Error creating User, all fileds are required"
    redirect_to new_client_path
  end

  def permit_params_user
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation)
  end

  def get_clients_by_agents_id
    Agent.where(agent_id: get_agents_id_by_broker).map do |agent|
      agent.clients
    end
  end

  def get_agents_id_by_broker
    Broker.find(current_user.id).agents.pluck(:id)
  end
end