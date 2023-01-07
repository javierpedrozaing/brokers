class TypeOfReference < ApplicationRecord
  has_many :referrals, class_name: "Referral"
end
