class Source < ApplicationRecord
  has_many :referrals, class_name: "Referral"
end
