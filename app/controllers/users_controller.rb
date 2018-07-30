class UsersController < ApplicationController
  include ApplicationHelper

  before_action :authorize_user, except: %i[new create]
  before_action :fetch_user, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to products_url
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
      redirect_to new_user_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to products_url
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :email, :contact, :role,
                                 :password)
  end

  def fetch_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:notice] = e.message
    redirect_to products_url
  end
end
