class AddReferencesToAgent < ActiveRecord::Migration[5.2]
  def change
    add_reference :agents, :broker, foreign_key: true
    add_reference :agents, :user, foreign_key: true
  end
end
