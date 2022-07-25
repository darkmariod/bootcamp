class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :title
      t.text :description
      t.text :sidebar
      t.references :user, null: false

      t.timestamps
    end
    add_index :communities, :name, unique: true
  end
end
