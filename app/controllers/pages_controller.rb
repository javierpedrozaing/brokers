class PagesController < ApplicationController
  def home
    if user_signed_in? && current_user.member_since.blank?
      redirect_to profile_index_path, id_user: current_user.id
    end
  end
end
