class CreateCaseNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :case_notes do |t|
      t.references :legal_case, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
