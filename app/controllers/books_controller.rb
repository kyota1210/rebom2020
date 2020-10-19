class BooksController < ApplicationController
  def index
    @books = Book.all
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

  private

  def book_params
    params.require(:book).permit(:image, :title, :author)
  end
end
