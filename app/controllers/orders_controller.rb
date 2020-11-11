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
      pay_book
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
    params.require(:order_address).permit(:zip_code, :prefecture_id, :city, :street, :building, :phone_number).merge(user_id: current_user.id, sale_id: params[:sale_id], token: params[:token])
  end

  def pay_book
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @sale.price,  # 本の価格
      card: order_address_params[:token], # カード情報
      currency: 'jpy'   # 通貨
    )
  end
end
