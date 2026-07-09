class AddWeeklyLimitToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :weekly_limit, :decimal, precision: 10, scale: 2, null: false, default: 20
  end
end
