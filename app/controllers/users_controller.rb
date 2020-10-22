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
    if @user.update(update_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private
  def update_params
    params.require(:user).permit(:image, :name, :text)
  end

  def move_to_index
    user =User.find(params[:id])
    unless user_signed_in? && current_user.id == user.id
      redirect_to root_path
    end
  end
end
