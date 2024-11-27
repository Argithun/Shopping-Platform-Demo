class AddCostToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :cost, :decimal, precision: 10, scale: 2
  end
end
