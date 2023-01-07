class Transaction < ApplicationRecord
  belongs_to :referred, class_name: "Referral", foreign_key: "referred_id"
  belongs_to :state, class_name: "State", foreign_key: "state_id"
  belongs_to :property_type, class_name: "PropertyType", foreign_key: "property_type_id"
end
