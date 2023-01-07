class AddReferredToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :referred, foreign_key: true
  end
end
