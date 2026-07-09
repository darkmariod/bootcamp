class CreateAlimonyCalculations < ActiveRecord::Migration[8.1]
  def change
    create_table :alimony_calculations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :legal_case, null: true, foreign_key: true
      t.string :applicant_name
      t.decimal :monthly_income
      t.boolean :iess_deducted
      t.integer :children_under_3
      t.integer :children_3_plus
      t.integer :claimed_children
      t.integer :disability_range
      t.integer :level
      t.decimal :percentage
      t.decimal :total_amount
      t.decimal :per_child_amount
      t.decimal :pension_amount
      t.decimal :disability_supplement
      t.json :details

      t.timestamps
    end
  end
end
