class AddFieldsToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :type_of_house, :string, :null => true 
    add_column :clients, :number_of_rooms, :integer, :null => true
    add_column :clients, :parkng_lot, :integer, :null => true
    add_column :clients, :budget, :string, :null => true
  end
end
