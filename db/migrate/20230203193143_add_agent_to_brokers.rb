class AddAgentToBrokers < ActiveRecord::Migration[5.2]
  def change
    add_reference :brokers, :agent, foreign_key: true
  end
end
