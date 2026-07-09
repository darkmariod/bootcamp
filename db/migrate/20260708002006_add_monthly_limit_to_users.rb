class AddMonthlyLimitToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :monthly_limit, :decimal, precision: 10, scale: 2
  end
end
