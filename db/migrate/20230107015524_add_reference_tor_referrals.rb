class AddReferenceTorReferrals < ActiveRecord::Migration[5.2]
  def change    
    add_reference :referrals, :user, foreign_key: true
  end
end
