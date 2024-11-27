class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :receiver
      t.string :shipping_address
      t.string :phone_number
      t.string :postal_code
      t.integer :quantity
      t.decimal :total_amount
      t.string :order_status

      t.timestamps
    end
  end
end
