class Product < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :product_images

  validates :title, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: true

  accepts_nested_attributes_for :product_images
end
