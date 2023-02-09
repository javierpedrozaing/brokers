class Broker < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :transations, class_name: "Transaction"
  has_many :agents, class_name: "Agent"
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }  



  def full_address
    [address, state, city].compact.join(', ')
  end

  # def send_notification_new_user
  #   UserMailer.welcome_email
  # end


end
