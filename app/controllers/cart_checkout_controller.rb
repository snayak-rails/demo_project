class CartCheckoutController < ApplicationController
  include ApplicationHelper

  before_action :fetch_cart
  before_action :fetch_cart_item, only: %i[update_cart_item destroy_cart_item]

  def new
    redirect_to cart_checkout_path(@cart.id)
  end

  def show
    @cart_items = @cart.cart_items.all
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

  def create_cart_item
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_checkout_path(@cart.id)
    else
      flash[:notice] = @cart_item.errors.full_messages.join('<br>')
    end
  end

  def update_cart_item
    if @cart_item.update(quantity: params[:updated_quantity])
      redirect_to cart_checkout_path(@cart.id)
    else
      flash[:notice] = 'Cart item update failed.'
    end
  end

  def destroy_cart_item
    @cart_item.destroy!
  rescue StandardError
    flash[:notice] = @cart.errors.full_messages.join('<br>')
  end

  def destroy
    unless @cart.destroy! flash[:notice] = @cart.errors.full_messages.join('<br>')
    end
  end

  private

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
    if @cart.save
      session[:cart_id] = @cart.id
      @cart
    else
      flash[:notice] = @cart.errors.full_messages.join('<br>')
      return
    end
  end
end
