class AddTypeOfRefToReferrals < ActiveRecord::Migration[5.2]
  def change
    add_reference :referrals, :type_of_ref, foreign_key: true
  end
end
