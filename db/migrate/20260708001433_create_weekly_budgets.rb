class CreateWeeklyBudgets < ActiveRecord::Migration[7.1]
  def change
    create_table :weekly_budgets do |t|
      t.date :week_start, null: false
      t.decimal :limit_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :carried_over, precision: 10, scale: 2, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :weekly_budgets, [:user_id, :week_start], unique: true
  end
end
