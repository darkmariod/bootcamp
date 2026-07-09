class CreateLegalCases < ActiveRecord::Migration[8.1]
  def change
    create_table :legal_cases do |t|
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :case_type
      t.integer :status
      t.string :title
      t.string :case_number
      t.string :court
      t.text :description

      t.timestamps
    end
  end
end
