class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.text :description
      t.integer :sold
      t.integer :status, default: 0
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
