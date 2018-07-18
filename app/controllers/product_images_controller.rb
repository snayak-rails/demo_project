class ProductImagesController < ApplicationController

  def index
    @product_images = @product.product_images.all
  end

end
