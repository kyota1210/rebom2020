class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    binding.pry
    if @user.valid?
      @user.update(update_params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  private
  def update_params
    params.require(:user).permit(:image, :name, :email, :text)
  end
end
