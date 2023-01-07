class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :origin_broker
      t.integer :destination_broker
      t.integer :origin_agent
      t.integer :assigned_agent
      t.string :property_address
      t.string :contract_price
      t.date :closing_date
      t.string :destination_broker_commission_percent
      t.string :destination_broker_commission
      t.string :origin_broker_commision_percent
      t.string :origin_broker_commission
      t.string :proof_check

      t.timestamps
    end
  end
end
