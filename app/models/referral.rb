class Referral < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :source, class_name: "Source", foreign_key: "source_id"
  belongs_to :time_frame, class_name: "TimeFrame", foreign_key: "time_frame_id"  
  has_many :transations, class_name: "Transaction"
end
