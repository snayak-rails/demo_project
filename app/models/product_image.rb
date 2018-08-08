# frozen_string_literal: true

# model for images of products
class ProductImage < ApplicationRecord
  mount_uploader :image, ProductImageUploader
  belongs_to :product
end
