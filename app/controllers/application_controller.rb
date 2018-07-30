class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # helper_method :current_user

  def start
    redirect_to products_url
  end

  def authorize_user
    redirect_to login_url if session[:user_id].nil?
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
    if @cart.save(validate: false)
      session[:cart_id] = @cart.id
      @cart
    else
      flash.now[:notice] = @cart.errors.full_messages.join('<br>')
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue ActionController::RoutingError
    render file: 'public/404.html', status: 404
  end
end
