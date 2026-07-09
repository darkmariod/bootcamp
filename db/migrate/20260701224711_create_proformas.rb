class CreateProformas < ActiveRecord::Migration[8.1]
  def change
    create_table :proformas do |t|
      t.references :client, null: false, foreign_key: true
      t.references :legal_case, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :number
      t.integer :status
      t.date :issued_on
      t.date :valid_until
      t.text :notes
      t.decimal :total_amount

      t.timestamps
    end
  end
end
