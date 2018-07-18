class UsersController < ApplicationController
  #before_action :authorize

  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to products_path
    else
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :email, :contact, :role, :password, :password_confirmation)
  end

end
