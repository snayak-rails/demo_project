# frozen_string_literal: true

# Contains methods for application wide usage
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def start
    redirect_to products_url
  end

  def authorize_user
    return unless session[:user_id].blank?
    flash[:notice] = 'You need to login for this action.'
    redirect_to products_url
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue ActionController::RoutingError
    render file: 'public/404', status: 404
  end

  def flash_ajax_error(format, record)
    flash.now[:notice] = record.errors.full_messages.join('<br>')
    format.js { render file: 'shared/flash' }
  end

  def flash_ajax_message(message)
    flash.now[:notice] = message
    render file: 'shared/flash.js.erb'
  end
end
