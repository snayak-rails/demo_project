class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    user = User.find_by_email(params[:email])
    flash[:notice] = 'Enter correct email and password.' if user.nil?
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to products_url
    else
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart_id] = nil
    redirect_to products_url
  end
end
