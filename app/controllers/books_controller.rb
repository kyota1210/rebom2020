class BooksController < ApplicationController
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
      render "new"
    end
  end

  private

  def book_params
    params.require(:book).permit(:image, :title, :author).merge(user_id: current_user.id)
  end
end
