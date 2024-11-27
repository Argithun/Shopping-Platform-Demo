class Product < ApplicationRecord
    validates :image_path, allow_blank: true, format: { with: /\Ahttps?:\/\/.+\.(png|jpg|jpeg|gif)\z/i, message: "must be a valid image URL" }
    has_many :cart_items, dependent: :destroy
    has_many :comments, dependent: :destroy
end
