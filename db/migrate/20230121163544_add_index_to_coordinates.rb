class AddIndexToCoordinates < ActiveRecord::Migration[5.2]
  def change
    add_index :brokers, [:latitude, :longitude]
  end
end
