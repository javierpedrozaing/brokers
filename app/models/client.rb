class Client < ApplicationRecord
  belongs_to :user
  belongs_to :agent
  belongs_to :broker
  has_many :transactions

  def full_name
    "#{self.user.first_name} #{self.user.last_name}"
  end
end
