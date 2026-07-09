class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0
      t.date :date, null: false
      t.integer :kind, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
