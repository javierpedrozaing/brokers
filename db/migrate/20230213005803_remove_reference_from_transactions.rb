class RemoveReferenceFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :transactions, :referred, index: true, foreign_key: true
  end
end
