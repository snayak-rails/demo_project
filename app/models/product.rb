# frozen_string_literal: true

# model for products
class Product < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :product_images, dependent: :destroy

  scope :searched_items, ->(searched_keyword) do
                           where('title ILIKE ? OR category ILIKE ?',
                                 "%#{searched_keyword}%", "%#{searched_keyword}%")
                         end

  validates :title, presence: true
  validates :category, presence: true, length: { maximum: 15 }
  validates_numericality_of :price, presence: true,
                                    greater_than_or_equal_to: 0
  validates_numericality_of :stock, presence: true, only_integer: true,
                                    greater_than_or_equal_to: 0

  accepts_nested_attributes_for :product_images
end
