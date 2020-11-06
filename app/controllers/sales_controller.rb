class SalesController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def new
    @book = Book.find(params[:id])
    @sale = Sale.new
  end

  def create
    @book = Book.find(params[:book_id])
    @sale = Sale.new(sale_params)
    if @sale.valid?
      @book.sell = :sell
      @book.save
      @sale.save
      redirect_to "/users/#{@book.user.id}"
    else
      render action: :new
    end
  end

  def edit
    @book = Book.find(params[:id])
    @sale = @book.sale
  end

  def update
    @book = Book.find(params[:book_id])
    @sale = Sale.find(params[:id])
    if @sale.valid?
      @sale.update(sale_params)
      redirect_to "/users/#{@book.user_id}"
    else
      render action: :edit
    end
  end

  def show
    @book = Book.find(params[:id])
    @sale = @book.sale
  end

  def destroy
    @book = Book.find(params[:book_id])
    @sale = Sale.find(params[:id])
    if @sale.valid?
      @sale.destroy
      @book.sell = false
      @book.save
      redirect_to root_path
    else
      render root_path
    end
  end

  private

  def sale_params
    params.require(:sale).permit(:status_id, :transfer_fee_id, :price).merge(book_id: params[:book_id])
  end
end
