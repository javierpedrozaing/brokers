class ProfileController < ApplicationController
  def index    
    @user = User.find(current_user.id)
    @role = current_user.role
    @agent = Agent.find_by_user_id(current_user.id)
    @broker = Broker.find_by_user_id(current_user.id)
  end

  def update_profile
    
  end
end
