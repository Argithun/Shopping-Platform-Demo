class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :sales
      t.string :image_path
      t.string :product_type
      t.string :color

      t.timestamps
    end
  end
end
