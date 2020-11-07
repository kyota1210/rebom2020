class OrdersController < ApplicationController
  def index
    @sale = Sale.find(params[:sale_id])
    @order_address = OrderAddress.new
  end

  def create
    @sale = Sale.find(params[:sale_id])
    book = @sale.book
    @order_address = OrderAddress.new(order_address_params)
    if @order_address.valid?
      @order_address.save
      book.sell = false
      book.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private
  def order_address_params
    params.require(:order_address).permit(:user_id, :sale_id, :zip_code, :prefecture_id, :city, :street, :building, :phone_number).merge(user_id: current_user.id, sale_id: params[:sale_id])
  end

end
