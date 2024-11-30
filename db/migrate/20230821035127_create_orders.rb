class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :address
      t.string :phone
      t.integer :status, default: 0
      t.integer :total_price
      t.string :reason_description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
