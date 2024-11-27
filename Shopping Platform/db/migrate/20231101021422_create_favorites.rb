class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :sales_count
      t.string :image_url
      t.string :product_type
      t.string :color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
