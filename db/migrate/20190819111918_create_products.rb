class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :serial_no, null: false, unique: true
      t.string :title, null: false 
      t.text :description
      t.decimal :price, null: false, precision: 12, scale: 2
      t.integer :quantity, null: false
      t.references :user, foreign_key: true, index:true

      t.timestamps
    end
  end
end
