# frozen_string_literal: true

# Cart logic for cart items and orders
class CartCheckoutController < ApplicationController
  include SessionsHelper
  include Available

  before_action :fetch_cart, except: %i[order_history]
  before_action :authorize_user, only: %i[order_history]
  before_action :fetch_cart_item,
                only: %i[increment_cart_item_quantity decrement_cart_item_quantity
                         destroy_cart_item]
  before_action :stock_available?, only: %i[add_to_cart]
  before_action :cart_items_in_stock?, only: %i[update]

  def index
    @cart.destroy_cart_items_for_nil_product
    @cart_items = @cart.cart_items.all
    @total_amount = @cart.total_amount unless @cart_items.blank?
  end

  def order_history
    @user_carts = current_user.carts.paid_carts
  end

  def add_to_cart
    product_id = params[:product_id]
    @cart_item = CartItem.where('cart_id = ? AND product_id = ?',
                                @cart.id, product_id).take
    return create_cart_item if @cart_item.blank?
    flash[:notice] = 'Item already added to cart.'
    redirect_to product_path(product_id)
  end

  def purchase
    @cart_items = @cart.cart_items.all
    return flash.now[:notice] = 'Your Cart is empty.' if @cart_items.blank?
    flash.now[:notice] = 'Please login to continue purchase.' unless logged_in?
  end

  def update
    if @cart.update_attributes(cart_params)
      remove_temp_cart_id
      @cart.update_cart_items
      flash[:success] = 'Order confirmed!'
    else
      flash[:error] += @cart.errors.full_messages.join('<br>')
    end
    redirect_to cart_checkout_index_path
  end

  def update_cart_item_quantity; end

  def increment_cart_item_quantity
    update_succeeded = @cart_item.update(quantity: @cart_item.quantity + 1)
    message = @cart_item.errors.full_messages.join('<br>')
    flash[:error] = message unless update_succeeded
    render :update_cart_item_quantity
  end

  def decrement_cart_item_quantity
    update_succeeded = @cart_item.update(quantity: @cart_item.quantity - 1)
    message = @cart_item.errors.full_messages.join('<br>')
    flash[:error] = message unless update_succeeded
    render :update_cart_item_quantity
  end

  def destroy_cart_item
    @cart_item.destroy
    redirect_to cart_checkout_index_path
  end

  def destroy
    @cart.destroy
  end

  private

  def cart_params
    total_amount = @cart.total_amount
    params.require(:cart)
          .permit(:name, :contact, :email, :address1, :city,
                  :state, :country, :pincode)
          .merge(total_amount: total_amount, is_paid: true)
  end

  def cart_item_params
    { product_id: params[:product_id], cart_id: @cart.id, quantity: 1 }
  end

  def fetch_cart
    if logged_in?
      if temp_cart_exists?
        @cart = Cart.merged_cart(fetch_current_user_cart, current_temp_cart)
        remove_temp_cart_id
        @cart
      else
        fetch_current_user_cart
      end
    else
      temp_cart_exists? ? @cart = current_temp_cart : create_temp_cart
    end
  end

  def fetch_current_user_cart
    @cart = Cart.active_cart(current_user.id).take
    @cart.blank? ? create_cart : @cart
  end

  def fetch_cart_item
    @cart_item = CartItem.find(params[:id])
    @product = Product.find(@cart_item.product_id)
  end

  def create_cart
    @cart = current_user.carts.new(is_paid: false)
    @cart.save(validate: false)
    @cart
  end

  def create_temp_cart
    @cart = Cart.new(is_paid: false)
    @cart.save(validate: false)
    save_temp_cart_id(@cart)
    @cart
  end

  def create_cart_item
    @cart_item = CartItem.create(cart_item_params)
    redirect_to cart_checkout_index_path
  end
end
