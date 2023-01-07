class AddSourceToReferrals < ActiveRecord::Migration[5.2]
  def change
    add_reference :referrals, :source, foreign_key: true
  end
end
