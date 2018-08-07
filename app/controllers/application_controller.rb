# frozen_string_literal: true

# Contains methods for application wide usage
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def start
    redirect_to products_url
  end

  def authorize_user
    return unless session[:user_id].nil?
    flash[:notice] = 'Please login to accesss the cart.'
    redirect_to products_url
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue ActionController::RoutingError
    render file: 'public/404.html', status: 404
  end
end
