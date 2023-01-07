class AddUserToBroker < ActiveRecord::Migration[5.2]
  def change
    add_reference :brokers, :user, foreign_key: true
  end
end
