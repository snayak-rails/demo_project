class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # helper_method :current_user

  def start
    redirect_to products_url
  end

  def authorize_user
    redirect_to login_url if session[:user_id].nil?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue ActionController::RoutingError
    render file: 'public/404.html', status: 404
  end
end
