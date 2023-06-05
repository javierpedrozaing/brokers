class UpdateFieldsForClients < ActiveRecord::Migration[5.2]
  def change    
    add_column :clients, :bed_rooms, :string, :null => true
    add_column :clients, :bath_rooms, :string, :null => true
    add_column :clients, :pool, :boolean, :default => false
  end
end
