class AddCommissionToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :commission, :string, :null => true
    add_column :users, :full_sale, :string, :null => true
  end
end
