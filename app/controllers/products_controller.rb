class ProductsController < ApplicationController

  #before_action :authorize

  def index
    @products = Product.all
  end

  def show
  end

  def new
  end

  def create
    if current_user.role == "seller" && current_user.products.create(product_params)
      redirect_to products_path
    else
      redirect_to new_product_path
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :category, :description, :price)
  end

end
