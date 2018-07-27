class ProductsController < ApplicationController
  include ApplicationHelper
  include ProductsHelper
  before_action :fetch_product,
                except: %i[index new create seller_dashboard]
  before_action :user_logged_in?, :verify_seller,
                except: %i[index show]

  # rescue_from ActionController::RoutingError, :with => :not_found

  def index
    # session[:user_id] = nil
    @products = Product.all
  end

  def show
  end

  def new
    @product = current_user.products.new
    @product_images = @product.product_images.build
  end

  def create
    @product = current_user.products.new(product_params)
    respond_to do |format|
      if @product.save
        params[:product_images]['image'].each do |a|
          @product_images = @product.product_images
          @product_images.create!(image: a, product_id: @product.id)
        end
        format.html { redirect_to '/seller_dashboard', notice: 'Product added!' }
      else
        format.html { redirect_to '/seller_dashboard', notice: 'Attempt failed!' }
      end
    end
  end

  def edit
  end

  def update
    # binding pry
    if @product.update_attributes(product_params)
      image_params = params[:product_images]['image']
      update_product_images(image_params)
      update_cart_items(product_params)
      redirect_to '/seller_dashboard'
    else
      render :edit
    end
  end

  def destroy
    destroy_product_images
    destroy_cart_items
    @product.destroy
    respond_to do |format|
      format.html { redirect_to '/seller_dashboard', notice: 'Product removed' }
    end
  end

  def seller_dashboard
    @seller_products = current_user.products.all
  end

  private

  def update_product_images(image_params)
    @product_images.zip(image_params).each do |product_image, p|
      product_image.update(image: p, product_id: @product.id)
    end
  end

  def update_cart_items(product_params)
    title = product_params[:title]
    price = product_params[:price]
    cart_items = CartItem.where('product_id = ?', @product.id)
    return if cart_items.blank?
    cart_items.each do |cart_item|
      cart_item.update(title: title, price: price)
    end
  end

  def verify_seller
    unless current_user.role == 'seller'
      flash[:notice] = 'You need a seller account to access a seller dashboard.'
      redirect_to '/login'
    end
  end

  def product_params
    image = { product_images_attributes: %i[id image product_id] }
    params.require(:product)
          .permit(:title, :category, :description, :price, image)
  end

  def destroy_product_images
    @product_images.each(&:remove_image!)
  end

  def destroy_cart_items
    cart_items = CartItem.where('product_id = ?', @product.id)
    return if cart_items.blank?
    cart_items.destroy_all
  end
end
