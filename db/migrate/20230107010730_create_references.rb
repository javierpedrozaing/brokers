class CreateReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.string :bundget_min
      t.string :bundget_max

      t.timestamps
    end
  end
end
