class Broker < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_many :transations, class_name: "Transaction"
end
