class AddClientReferenceToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :client, foreign_key: true
  end
end
