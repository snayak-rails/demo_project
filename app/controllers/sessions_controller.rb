# frozen_string_literal:true

# Contains logic for user-login and logout
class SessionsController < ApplicationController
  include SessionsHelper
  include Redirection

  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      log_in user
      flash[:notice] = 'Welcome ' + user.name
      redirect_by_role user
    else
      flash[:error] = 'Enter correct email and password.'
      redirect_to products_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to products_path
  end
end
