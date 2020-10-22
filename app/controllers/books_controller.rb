class BooksController < ApplicationController
  before_action :move_to_index, only: [:edit, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    @books = Book.all.order('created_at DESC')
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.valid?
      @book.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.valid?
      @book.update(book_params)
      redirect_to user_path(@book.user.id)
    else
      render action: :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    if book.valid?
      book.destroy
      redirect_to user_path(book.user.id)
    end
  end

  private

  def book_params
    params.require(:book).permit(:image, :title, :author).merge(user_id: current_user.id)
  end

  def move_to_index
    book = Book.find(params[:id])
    unless user_signed_in? && current_user.id == book.user.id
      redirect_to root_path
    end
  end
end
