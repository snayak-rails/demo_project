# frozen_string_literal: true

# model for cart_items in user cart
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_numericality_of :quantity, only_integer: true,
                                       greater_than_or_equal_to: 1
end
