class UsersController < ApplicationController
  # before_action :authorize
  before_action :set_user, only: %i[show edit update destroy]

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
      flash[:error] = @user.errors.full_messages.join('<br>')
      redirect_to new_user_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :email, :contact, :role, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
