class AddAgentsToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :broker, foreign_key: true
    add_reference :transactions, :agent, foreign_key: true
  end
end
