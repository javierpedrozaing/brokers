class UpdateTransactionTable < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :commission, :string, :null => true
    remove_column :transactions, :destination_broker_commission_percent
    remove_column :transactions, :destination_broker_commission
    remove_column :transactions, :origin_broker_commision_percent
    remove_column :transactions, :origin_broker_commission
    rename_column :transactions, :closing_date, :close_date
    change_column :transactions, :close_date, :string
  end
end
