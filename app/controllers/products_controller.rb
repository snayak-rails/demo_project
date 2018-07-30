class ProductsController < ApplicationController
  include ApplicationHelper
  before_action :fetch_product,
                except: %i[index new create seller_dashboard]
  before_action :authorize_user, :authorize_seller,
                except: %i[index show]

  after_action :destroy_product_images, :destroy_cart_items, only: %i[destroy]

  ROLE_SELLER = 'seller'.freeze

  def index
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
    if @product.save
      params[:product_images]['image'].each do |a|
        @product.product_images.create!(image: a, product_id: @product.id)
      end
      flash[:notice] = 'Product added!'
    else
      flash[:notice] = 'Attempt failed.'
    end
    redirect_to seller_dashboard_url
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      image_params = params[:product_images]['image']
      update_product_images(image_params)
      update_cart_items(product_params)
      redirect_to seller_dashboard_url
    else
      render :edit
    end
  end

  def destroy
    @product.destroy ? flash[:notice] = 'Product removed' : flash[:notice] = 'Attempt failed'
    redirect_to seller_dashboard_url
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

  def authorize_seller
    return if current_user.role == ROLE_SELLER
    flash[:notice] = 'You need a seller account for this action.'
    redirect_to login_url
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
    cart = fetch_cart
    cart_items = CartItem.where('product_id = ? AND cart_id = ?',
                                @product.id, cart.id)
    return if cart_items.blank?
    cart_items.destroy_all
  end

  def fetch_product
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = e.message
      redirect_to products_url
    end
    @product_images = @product.product_images.all
  end
end
