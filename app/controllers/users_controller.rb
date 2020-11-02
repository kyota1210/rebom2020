class UsersController < ApplicationController
  before_action :move_to_index, only: [:edit, :update]
  before_action :find_user_id, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
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
    user = User.find(params[:id])
    redirect_to root_path unless user_signed_in? && current_user.id == user.id
  end

  def find_user_id
    @user = User.find(params[:id])
  end
end
