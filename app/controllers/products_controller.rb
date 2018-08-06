class ProductsController < ApplicationController
  include ApplicationHelper
  before_action :fetch_product,
                except: %i[index new create seller_dashboard searched_items]
  before_action :authorize_user, except: %i[index show searched_items]
  before_action :authorize_seller,
                only: %i[seller_dashboard new create update edit destroy]
  after_action :destroy_product_images, only: %i[destroy]

  def index
    @products = Product.all.paginate(page: params[:page], per_page: 2)
  end

  def show
  end

  def new
    @product = current_user.products.new
    @product_images = @product.product_images.build
  end

  def create
    respond_to do |format|
      @product = current_user.products.new(product_params)
      if @product.save
        add_product_images unless params[:product_images].blank?
        flash[:notice] = 'Product added!'
        format.html { redirect_to seller_dashboard_url }
      else
        flash.now[:notice] = @product.errors.full_messages.join('<br>')
        format.js { render file: 'shared/flash' }
      end
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      image_params = params[:product_images]
      update_product_images(image_params) if image_params.present?
      redirect_to seller_dashboard_url
    else
      flash[:notice] = @product.errors.full_messages.join('<br>')
      redirect_to edit_product_url(@product.id)
    end
  end

  def destroy
    @product.destroy ? flash[:notice] = 'Product removed' : flash[:notice] = 'Attempt failed'
    redirect_to seller_dashboard_url
  end

  def seller_dashboard
    @seller_products = current_user.products.all
  end

  def searched_items
    @searched_items = Product.where('title ILIKE ? OR category ILIKE ?',
                                    "%#{params[:search]}%", "%#{params[:search]}%")
    flash[:notice] = 'No products found.' if @searched_items.blank?
    flash.discard
  end

  private

  def add_product_images
    params[:product_images]['image'].each do |a|
      @product.product_images.create!(image: a, product_id: @product.id)
    end
  end

  def update_product_images(image_params)
    @product_images.zip(image_params['image']).each do |product_image, p|
      product_image.update(image: p, product_id: @product.id)
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
    @product_images.each(&:remove_image!) unless @product_images.blank?
  end

  def fetch_product
    @product = Product.find(params[:id])
    @product_images = @product.product_images.all
  rescue ActiveRecord::RecordNotFound => e
    flash[:notice] = e.message
    redirect_to products_url
  end
end
