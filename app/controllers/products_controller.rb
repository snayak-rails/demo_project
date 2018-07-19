class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    @product_images = @product.product_images.all 
  end

  def new
    @product = current_user.products.new
    @product_images = @product.product_images.build
  end

  def create
    @product = current_user.products.new(product_params)
    #binding pry
    respond_to do |format|
      if @product.save
        params[:product_images]['image'].each do |a|
          @product_images = @product.product_images.create!(:image => a, :product_id => @product.id)
          #binding pry
      end
        format.html { redirect_to new_product_path, notice: "Product added successfully!" }
      else
        format.html { redirect_to new_product_path, notice: "Attempt unsucessful."}
      end
    end

  end

  def destroy

    @product.product_images.all.each do |product_image|
      product_image.remove_image!
    end
    #binding pry
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_path, notice: "Product removed" }
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :category, :description, :price, product_images_attributes: [:id, :image, :product_id])
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
