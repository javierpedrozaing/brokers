class RemoveReferenceAgentForBrokers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :brokers, :agent, foreign_key: true
  end
end
