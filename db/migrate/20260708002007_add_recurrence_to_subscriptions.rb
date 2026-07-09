class AddRecurrenceToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :frequency, :string, default: "monthly", null: false
    add_column :subscriptions, :day_of_week, :integer
    add_column :subscriptions, :auto_create, :boolean, default: false, null: false
    add_column :subscriptions, :last_created_at, :datetime
    add_reference :subscriptions, :category, foreign_key: true
  end
end
