class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :photo
      t.date :member_since
      t.date :member_end

      t.timestamps
    end
  end
end
