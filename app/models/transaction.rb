class Transaction < ApplicationRecord    
  belongs_to :client
  has_one_attached :proof_check, dependent: :purge_later
end
