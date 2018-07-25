class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def start
    redirect_to products_path
  end

  # def not_found
  #  raise ActionController::RoutingError.new('Not Found')
  # rescue ActionController::RoutingError
  #  render file: 'public/404.html', status: 404
  # end
end
