# frozen_string_literal: true

# User creation and profile settings
class UsersController < ApplicationController
  include SessionsHelper
  include Redirection

  before_action :authorize_user, except: %i[new create]
  before_action :fetch_user, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = 'Welcome ' + @user.name
      redirect_by_role @user
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
      redirect_to new_user_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to products_path
    else
      flash[:error] = @user.errors.full_messages.join('<br>')
      redirect_to edit_user_path(@user.id)
    end
  end

  def destroy
    @user.destroy
    log_out
    flash[:success] = 'Your account has been deleted.'
    redirect_to products_path
  end

  private

  def user_params
    role = Constants::ROLE_SELLER if params['user']['role'] == '1'
    role = Constants::ROLE_BUYER if params['user']['role'] == '0'
    params.require(:user).permit(:name, :gender, :email, :contact, :role,
                                 :password, :password_confirmation)
                         .merge(role: role)
  end

  def fetch_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:notice] = e.message
    redirect_to products_path
  end
end
