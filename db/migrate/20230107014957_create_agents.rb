class CreateAgents < ActiveRecord::Migration[5.2]
  def change
    create_table :agents do |t|
      t.string :birthday, default: ""
      t.string :address, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip_code, default: ""

      t.timestamps
    end
  end
end
