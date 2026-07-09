class CreateProformaItems < ActiveRecord::Migration[8.1]
  def change
    create_table :proforma_items do |t|
      t.references :proforma, null: false, foreign_key: true
      t.string :description
      t.decimal :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
