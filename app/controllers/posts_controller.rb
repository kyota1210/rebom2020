class PostsController < ApplicationController
  before_action :move_to_index1, only: [:edit, :destroy]
  before_action :move_to_index2, only: :new

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.valid?
      @post.save
      redirect_to "/books/#{@post.book.id}"
    else
      render action: :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    if @post.valid?
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to book_path(@post.book.id)
  end

  private

  def post_params
    params.require(:post).permit(:highlight, :text).merge(book_id: params[:book_id])
  end

  def move_to_index1
    post = Post.find(params[:id])
    redirect_to root_path unless user_signed_in? && current_user.id == post.book.user.id
  end

  def move_to_index2
    post = Post.new
    book = Book.find(params[:book_id])
    redirect_to root_path unless user_signed_in? && current_user.id == book.user.id
  end
end
