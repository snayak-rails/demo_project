# frozen_string_literal: true

# Helper methods to maintain user state and cart state
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.blank?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def save_temp_cart_id(cart)
    session[:cart_id] = cart.id
  end

  def current_temp_cart
    @current_temp_cart ||= Cart.find_by(id: session[:cart_id])
  end

  def temp_cart_exists?
    !current_temp_cart.blank?
  end

  def remove_temp_cart_id
    session.delete(:cart_id)
    @current_temp_cart = nil
  end

  def current_cart
    if logged_in?
      @cart = Cart.active_cart(current_user.id).take
    else
      current_temp_cart
    end
  end
end
