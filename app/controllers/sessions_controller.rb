# frozen_string_literal:true

# Contains logic for user-login and logout
class SessionsController < ApplicationController
  include SessionsHelper

  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      log_in user
      remember user
      flash[:notice] = 'Welcome ' + user.name
    else
      flash[:notice] = 'Enter correct email and password.'
    end
    redirect_to products_url
  end

  def destroy
    log_out if logged_in?
    redirect_to products_url
  end
end
