class CreateBrokers < ActiveRecord::Migration[5.2]
  def change
    create_table :brokers do |t|
      t.string :company_name, default: ""
      t.string :company_licence, default: ""
      t.integer :years_in_bussiness, default: ""
      t.string :insurance_carrier, default: ""
      t.string :insurance_policy, default: ""
      t.string :licence, default: ""
      t.date :licencia_expiration_date, default: ""
      t.string :reserver_zip_code, default: ""
      t.string :birthday, default: ""
      t.string :address, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.boolean :director, default: ""

      t.timestamps
    end
  end
end
