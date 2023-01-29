class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :brokers, :latitude, :float
    add_column :brokers, :longitude, :float
  end
end
