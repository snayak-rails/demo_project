# frozen_string_literal:true

# Contains logic for user-login and logout
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
    else
      flash[:notice] = 'Enter correct email and password.'
    end
    redirect_to products_url
  end

  def destroy
    session[:user_id] = nil
    session[:cart_id] = nil
    redirect_to products_url
  end
end
