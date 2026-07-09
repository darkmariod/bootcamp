class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :cedula
      t.string :email
      t.string :phone
      t.string :address
      t.text :notes

      t.timestamps
    end
  end
end
