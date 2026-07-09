class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0
      t.text :description
      t.date :issue_date, null: false
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
