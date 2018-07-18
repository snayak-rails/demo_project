class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def start
    #if current_user
    #  redirect_to products_path
    #else
    #  redirect_to '/login'
    #end
    redirect_to products_path
  end
  
end
