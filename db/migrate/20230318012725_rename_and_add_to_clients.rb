class RenameAndAddToClients < ActiveRecord::Migration[5.2]
  def change
    rename_column :clients, :type_of_house, :type_of_property
    add_column :clients, :number_of_bathrooms, :string, :null => true
  end
end
