class Product < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :product_images, dependent: :destroy

  validates :title, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: true

  accepts_nested_attributes_for :product_images
end
