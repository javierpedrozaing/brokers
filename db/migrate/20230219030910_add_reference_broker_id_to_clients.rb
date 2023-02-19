class AddReferenceBrokerIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_reference :clients, :broker, foreign_key: true
  end
end
