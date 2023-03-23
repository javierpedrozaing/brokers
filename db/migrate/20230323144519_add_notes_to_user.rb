class AddNotesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notes, :string, :null => true
  end
end
