class UsersController < ApplicationController
  before_action :move_to_index, only: :edit

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.valid?
      @user.update(update_params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  private
  def update_params
    params.require(:user).permit(:image, :name, :email, :text, :password)
  end

  def move_to_index
    user =User.find(params[:id])
    unless current_user.id && user_signed_in? == user.id
      redirect_to root_path
    end
  end
end
