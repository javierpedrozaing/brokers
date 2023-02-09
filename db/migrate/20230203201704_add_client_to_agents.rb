class AddClientToAgents < ActiveRecord::Migration[5.2]
  def change
    add_reference :agents, :client, foreign_key: true
  end
end
