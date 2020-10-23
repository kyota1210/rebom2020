class UsersController < ApplicationController
  before_action :move_to_index, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_paramas)
      redirect_to user_path(@user.id)
    elsif @user.update_without_current_password(no_pass_update_params)
      @user.update(no_pass_update_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private
  def no_pass_update_params
    params.require(:user).permit(:image, :name, :text)
  end
  
  def update_paramas
    params.require(:user).permit(:image, :name, :email, :password, :text)
  end

  def move_to_index
    user =User.find(params[:id])
    unless user_signed_in? && current_user.id == user.id
      redirect_to root_path
    end
  end
end
