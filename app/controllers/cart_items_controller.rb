class CartItemsController < ApplicationController
  include ApplicationHelper

  def index
    @cart_items = CartItem.all
  end

  def create_cart_item
    # session[:cart_id] = nil
    if session[:cart_id].nil?
      @cart = current_user.carts.new(is_paid: false)
      session[:cart_id] = @cart.id if @cart.save
    end
    @cart_item = CartItem.where('cart_id = ? AND product_id = ?',
                                session[:cart_id], params[:product_id]).take
    # binding pry
    @cart_item.nil? ? create : update(@cart_item)
    redirect_to cart_items_path
  end

  def new
  end

  def create
    @cart_item = CartItem.new(product_id: params[:product_id],
                              cart_id: session[:cart_id],
                              price: params[:price], quantity: 1)
    @cart_item.save
  end

  def update(cart_item)
    cart_item.update_attribute(quantity: @cart_item[:quantity] + 1)
  end
end
