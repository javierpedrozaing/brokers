class AddStateToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :state, foreign_key: true
  end
end
