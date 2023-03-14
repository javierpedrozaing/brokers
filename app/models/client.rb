class Client < ApplicationRecord
  belongs_to :user
  belongs_to :agent
  has_many :transactions

  def full_name
    "#{self.user.first_name} #{self.user.last_name}"
  end
end
