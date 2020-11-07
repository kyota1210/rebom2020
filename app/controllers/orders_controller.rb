class OrdersController < ApplicationController
  def index
    @sale = Sale.find(params[:sale_id])
    @order = Order.new
  end
end
