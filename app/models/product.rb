class Product < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :product_images

  accepts_nested_attributes_for :product_images
end
