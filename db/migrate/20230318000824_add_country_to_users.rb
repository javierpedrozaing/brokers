class AddCountryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :brokers, :country, :string, :null => true
    add_column :agents, :country, :string, :null => true
  end
end
