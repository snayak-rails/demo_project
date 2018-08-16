# frozen_string_literal:true

# Contains logic for displaying products and actions for seller
class ProductsController < ApplicationController
  include SessionsHelper
  include ApplicationHelper
  before_action :fetch_product,
                except: %i[index new create seller_dashboard searched_items]
  before_action :authorize_user, except: %i[index show searched_items]
  before_action :authorize_seller,
                only: %i[seller_dashboard new create update edit destroy]
  after_action :destroy_product_images, only: %i[destroy]

  def index
    respond_to do |format|
      format.html do
        @products = Product.all.paginate(page: params[:page], per_page: 12)
      end
      format.js do
        @products = Product.searched_items(params[:search])
        @products = @products.paginate(page: params[:page], per_page: 12)
      end
    end
  end

  def show; end

  def new
    @product = current_user.products.new
    @product_images = @product.product_images.build
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      add_product_images
      flash[:notice] = 'Product added!'
      redirect_to seller_dashboard_products_url
    else
      flash_ajax_error(@product.errors.full_messages.join('<br>'))
    end
  end

  def edit; end

  def update
    if @product.update_attributes(product_params)
      add_product_images
      remove_images
      redirect_to seller_dashboard_products_url
    else
      flash[:error] = @product.errors.full_messages.join('<br>')
      redirect_to edit_product_url(@product.id)
      # flash_ajax_error(@product.errors.full_messages.join('<br>'))
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = 'Product removed'
      redirect_to seller_dashboard_products_url
    else
      flash_ajax_error(@product.errors.full_messages.join('<br>'))
    end
  end

  def seller_dashboard
    @seller_products = current_user.products.all
                                   .paginate(page: params[:page], per_page: 12)
  end

  private

  def authorize_seller
    return if current_user.role == Constants::ROLE_SELLER
    flash[:notice] = 'You need a seller account for this action.'
    redirect_to products_url
  end

  def fetch_product
    @product = Product.find(params[:id])
    @product_images = @product.product_images.all
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = e.message
    redirect_to products_url
  end

  def product_params
    image = { product_images_attributes: %i[id image product_id] }
    params.require(:product)
          .permit(:title, :category, :description, :price, :stock, image)
  end

  def add_product_images
    return if params[:product_images].blank?
    params[:product_images]['image'].each do |a|
      @product.product_images.create!(image: a, product_id: @product.id)
    end
  end

  def remove_images
    return if params['image_ids'].blank?
    params['image_ids'].each do |image_id|
      ProductImage.find(image_id).remove_image!
      ProductImage.destroy(image_id)
    end
  end

  def destroy_product_images
    @product_images.each(&:remove_image!) unless @product_images.blank?
  end
end
