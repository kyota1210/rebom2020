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
    tag = params[:book][:name].split(",")
    if @book.valid?
      @book.save
      @book.save_books(tag)
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
    @tag = @book.tags.pluck(:name)
  end

  def update
    @book = Book.find(params[:id])
    tag = params[:book][:name].split(",")
    if @book.valid?
      @book.update(book_params)
      @book.save_books(tag)
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
    redirect_to root_path unless user_signed_in? && current_user.id == book.user.id
  end
end
