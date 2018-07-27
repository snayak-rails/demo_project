module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_logged_in?
    redirect_to '/login' if session[:user_id].nil?
  end
end
