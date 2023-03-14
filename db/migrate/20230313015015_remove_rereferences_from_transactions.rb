class RemoveRereferencesFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :transactions, :agent, foreign_key: true
    remove_reference :transactions, :broker, foreign_key: true
    remove_reference :transactions, :property_type, foreign_key: true
    remove_reference :transactions, :state, foreign_key: true
  end
end
