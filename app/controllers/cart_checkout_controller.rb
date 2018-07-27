class CartCheckoutController < ApplicationController
  include ApplicationHelper

  before_action :user_logged_in?, :fetch_cart
  before_action :fetch_cart_item, only: %i[update_cart_item destroy_cart_item]

  def index
    flash[:notice] = 'You cannot access another cart' if @cart.id.nil?
    @cart_items = @cart.cart_items.all
  end

  def order_history
    @user_carts = current_user.carts.where('is_paid = ?', true)
  end

  def add_to_cart
    @cart_item = CartItem.where('cart_id = ? AND product_id = ?',
                                session[:cart_id], params[:product_id]).take
    if @cart_item.nil?
      create_cart_item
    else
      flash[:notice] = 'Item already added to cart.'
      redirect_to product_path(params[:product_id])
    end
  end

  def purchase
    # binding pry
    @cart_items = @cart.cart_items.all
    if @cart_items.blank?
      flash[:notice] = 'Your cart is empty.'
      redirect_to cart_checkout_index_path
    end
  end

  def update
    # binding pry
    begin
      @cart.update!(purchase_params)
      flash[:notice] = 'Order confirmed!'
    rescue ActiveRecord::RecordInvalid => e
      flash[:notice] = e.record.errors.full_messages.join('<br>')
    end
    redirect_to cart_checkout_index_path
  end

  def create_cart_item
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_checkout_index_path
    else
      flash[:notice] = @cart_item.errors.full_messages.join('<br>')
    end
  end

  def update_cart_item
    begin
      @cart_item.update!(quantity: params[:updated_quantity])
    rescue ActiveRecord::RecordInvalid => e
      flash[:notice] = e.record.errors.full_messages.join('<br>')
      # redirect_to cart_checkout_index_path
    end
    redirect_to cart_checkout_index_path
  end

  def destroy_cart_item
    redirect_to cart_checkout_index_path if @cart_item.destroy
    flash[:notice] = @cart_item.errors.full_messages.join('<br>')
  end

  def destroy
    unless @cart.destroy! flash[:notice] = @cart.errors.full_messages.join('<br>')
    end
  end

  private

  def calculate_total_amount(cart_items)
    total_amount = 0
    cart_items.each do |cart_item|
      total_amount += cart_item.price * cart_item.quantity
    end
    total_amount
  end

  def purchase_params
    cart_params = params[:cart]
    @cart_items = @cart.cart_items.all
    total_amount = calculate_total_amount(@cart_items)
    { name: cart_params[:name], contact: cart_params[:contact], email: cart_params[:email],
      address1: cart_params[:address1], city: cart_params[:city], state: cart_params[:state],
      country: cart_params[:country], pincode: cart_params[:pincode],
      total_amount: total_amount, is_paid: true }
  end

  def cart_item_params
    { product_id: params[:product_id], cart_id: session[:cart_id],
      price: params[:price], title: params[:title], quantity: 1 }
  end

  def fetch_cart_item
    @cart_item = CartItem.find(params[:id])
  rescue StandardError
    flash[:notice] = @cart_item.errors.full_messages.join('<br>')
    redirect_to product_path(params[:product_id])
  end

  def fetch_cart
    @cart = Cart.where('user_id = ? AND is_paid = ?',
                       current_user.id, false).take
    @cart.nil? ? create_cart : session[:cart_id] = @cart.id
  end

  def create_cart
    @cart = current_user.carts.new(is_paid: false)
    if @cart.save(validate: false)
      session[:cart_id] = @cart.id
      @cart
    else
      flash.now[:notice] = @cart.errors.full_messages.join('<br>')
    end
  end
end
