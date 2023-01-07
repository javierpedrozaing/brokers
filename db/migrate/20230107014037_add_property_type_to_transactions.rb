class AddPropertyTypeToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :property_type, foreign_key: true
  end
end
