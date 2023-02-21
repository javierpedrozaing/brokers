class AddAgentIdToBrokers < ActiveRecord::Migration[5.2]
  def change
    add_column :brokers, :agent_id, :integer, :null => true
  end
end
