class RemoveReferenceFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :transactions, :referred, foreign_key: true
  end
end
