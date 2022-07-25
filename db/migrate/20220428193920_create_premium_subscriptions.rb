class CreatePremiumSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :premium_subscriptions do |t|
      t.string :plan
      t.string :customer_id
      t.string :subscription_id
      t.string :status
      t.string :interval
      t.datetime :current_period_end
      t.datetime :current_period_start
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
