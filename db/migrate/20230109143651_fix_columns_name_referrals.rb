class FixColumnsNameReferrals < ActiveRecord::Migration[5.2]
  def change
    rename_column :referrals, :bundget_min, :budget_min
    rename_column :referrals, :bundget_max, :budget_max
  end
end
