# frozen_string_literal: true

# Contains methods for application wide usage
class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  def start
    redirect_to products_path
  end

  def authorize_user
    return if logged_in?
    flash[:notice] = 'You need to login for this action.'
    redirect_to products_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue ActionController::RoutingError
    render file: 'public/404', status: 404
  end
end
