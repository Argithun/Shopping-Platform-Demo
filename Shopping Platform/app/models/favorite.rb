class Favorite < ApplicationRecord
  validates :image_url, allow_blank: true, format: { with: /\Ahttps?:\/\/.+\.(png|jpg|jpeg|gif)\z/i, message: "must be a valid image URL" }
  belongs_to :user
end
