class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :has_valid_role

  def index
    @users = User.all.where('id > ?', 0)
  end

  def show_user
    @user = User.find(params[:user_id])
  end

  def edit_user
    user_id = params[:user_id]
    user = User.find(user_id)
    user.first_name = params[:first_name] if params[:first_name]
    user.last_name = params[:last_name] if params[:last_name]
    user.phone = params[:phone] if params[:phone]
    user.email = params[:email] if params[:email]
    user.user_state = params[:user_state] if params[:user_state]
    
    if user.save!
      redirect_to dashboard_path(user_id), flash: {notice: "User successfully updated"}
    else
      render :edit
    end
  end

  private 

  def has_valid_role
    redirect_to root_path unless current_user.role.downcase == 'admin'
  end
end
