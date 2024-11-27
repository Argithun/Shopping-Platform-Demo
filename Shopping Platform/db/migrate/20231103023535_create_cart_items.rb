class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.string :user_email
      t.string :product_name
      t.integer :quantity
      t.datetime :added_at
      t.timestamps
    end
  end
end
