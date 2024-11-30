class AddDefaultToProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :sold, from: nil, to: 0
  end
end
