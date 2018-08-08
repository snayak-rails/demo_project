class Product < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :product_images, dependent: :destroy

  validates :title, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: true
  validates_numericality_of :stock, only_integer: true,
                                    greater_than_or_equal_to: 1

  accepts_nested_attributes_for :product_images
end
