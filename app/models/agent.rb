class Agent < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"    
  has_many :transations, class_name: "Transaction"
  has_many :clients, class_name: "Client"

  def full_name
    "#{self.user.first_name} #{self.user.last_name}"     
  end
end
