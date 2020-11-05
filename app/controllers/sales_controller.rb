class SalesController < ApplicationController
before_action :authenticate_user!, only: [:new]

  def new
    @book = Book.find(params[:id])
    @book_sale = BookSale.new
  end

  def create
    @book = Book.find(params[:book_id])
    @book_sale = BookSale.new(sale_params)
    if @book_sale.valid?
      @book.sell = :sell
      @book.save
      @book_sale.save
      redirect_to "/users/#{@book.user.id}"
    else
      render action: :new
    end
  end

  private

  def sale_params
    params.require(:book_sale).permit(:sell, :status, :transfer_fee, :price).merge(book_id: params[:book_id])
  end
end
