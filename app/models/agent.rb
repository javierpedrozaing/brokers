class Agent < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :broker, class_name: "Broker", foreign_key: "broker_id" # verify if is needed
  has_many :transations, class_name: "Transaction"
end
