class SalesController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :find_bookid, only: [:new, :edit, :show]
  before_action :find_book_id, only: [:create, :update, :destroy]

  def new
    @sale = Sale.new
  end

  def create
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
    @sale = @book.sale
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.valid?
      @sale.update(sale_params)
      redirect_to "/users/#{@book.user_id}"
    else
      render action: :edit
    end
  end

  def show
    @sale = @book.sale
  end

  def destroy
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

  def find_bookid
    @book = Book.find(params[:id])
  end

  def find_book_id
    @book = Book.find(params[:book_id])
  end

  def sale_params
    params.require(:sale).permit(:status_id, :transfer_fee_id, :price).merge(book_id: params[:book_id])
  end
end
