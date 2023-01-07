class CreateBrokers < ActiveRecord::Migration[5.2]
  def change
    create_table :brokers do |t|
      t.string :company_name
      t.string :company_licence
      t.integer :years_in_bussiness
      t.string :insurance_carrier
      t.string :insurance_policy
      t.string :licence
      t.date :licencia_expiration_date
      t.string :reserver_zip_code
      t.string :birthday
      t.string :address
      t.string :city
      t.string :state
      t.boolean :director

      t.timestamps
    end
  end
end
