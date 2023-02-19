class AddUserStateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_state, :string, :default => "inactive"
  end
end
