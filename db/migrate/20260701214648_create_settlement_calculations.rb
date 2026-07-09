class CreateSettlementCalculations < ActiveRecord::Migration[8.1]
  def change
    create_table :settlement_calculations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :legal_case, null: true, foreign_key: true
      t.string :worker_name
      t.decimal :monthly_salary
      t.date :start_date
      t.date :end_date
      t.integer :termination_reason
      t.integer :region
      t.integer :vacation_days_taken
      t.boolean :fondos_reserva_paid
      t.decimal :total_amount
      t.json :details

      t.timestamps
    end
  end
end
