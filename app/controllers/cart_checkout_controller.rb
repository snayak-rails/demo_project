# frozen_string_literal: true

# Cart logic for cart items and orders
class CartCheckoutController < ApplicationController
  include ApplicationHelper

  before_action :authorize_user, :fetch_cart
  before_action :fetch_cart_item,
                only: %i[update_cart_item_quantity destroy_cart_item]

  def index
    @cart.destroy_cart_items_for_nil_product
    @cart_items = @cart.cart_items.all
    @total_amount = @cart.total_amount unless @cart_items.blank?
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
    @cart_items = @cart.cart_items.all
    return unless @cart_items.blank?
    flash.now[:notice] = 'Your cart is empty.'
    render file: 'shared/flash.js.erb'
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        @cart.update_cart_items
        session[:cart_id] = nil
        flash.now[:notice] = 'Order confirmed!'
        format.html { render :index }
      else
        flash.now[:notice] = @cart.errors.full_messages.join('<br>')
        format.js { render file: 'shared/flash' }
      end
    end
  end

  def create_cart_item
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_checkout_index_url
    else
      flash[:notice] = @cart_item.errors.full_messages.join('<br>')
    end
  end

  def update_cart_item_quantity
    @cart_item.update(quantity: params[:updated_quantity])
  end

  def destroy_cart_item
    redirect_to cart_checkout_index_url if @cart_item.destroy
    flash[:notice] = @cart_item.errors.full_messages.join('<br>')
  end

  def destroy
    flash[:notice] = @cart.errors.full_messages.join('<br>') unless @cart.destroy
  end

  private

  def cart_params
    cart_params = params[:cart]
    @cart_items = @cart.cart_items.all
    total_amount = @cart.total_amount
    { name: cart_params[:name], contact: cart_params[:contact], email: cart_params[:email],
      address1: cart_params[:address1], city: cart_params[:city], state: cart_params[:state],
      country: cart_params[:country], pincode: cart_params[:pincode],
      total_amount: total_amount, is_paid: true }
  end

  def cart_item_params
    { product_id: params[:product_id], cart_id: session[:cart_id],
      quantity: 1 }
  end

  def fetch_cart_item
    @cart_item = CartItem.find(params[:id])
    @product = Product.find(@cart_item.product_id)
  rescue StandardError
    flash[:notice] = @cart_item.errors.full_messages.join('<br>')
    redirect_to product_path(params[:product_id])
  end

  def fetch_cart
    return @cart = Cart.find(session[:cart_id]) if session[:cart_id]
    @cart = Cart.where('user_id = ? AND is_paid = ?',
                       current_user.id, false).take
    @cart.nil? ? create_cart : session[:cart_id] = @cart.id
    @cart
  end

  def create_cart
    @cart = current_user.carts.new(is_paid: false)
    error_message = @cart.errors.full_messages.join('<br>')
    if @cart.save(validate: false)
      session[:cart_id] = @cart.id
      @cart
    else
      flash.now[:notice] = error_message
    end
  end
end
