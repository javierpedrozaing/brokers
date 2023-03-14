class Broker < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :transactions
  has_many :agents, class_name: "Agent"
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }  

  def full_address
    [address, state, city].compact.join(', ')
  end

  def full_name
    "#{self.user.first_name} #{self.user.last_name}"     
  end

  # def send_notification_new_user
  #   UserMailer.welcome_email
  # end


end
