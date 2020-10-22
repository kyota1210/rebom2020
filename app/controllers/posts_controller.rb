class PostsController < ApplicationController
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
    post = Post.find(params[:id])
    if post.valid?
      post.update(post_params)
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:highlight, :text).merge(book_id: params[:book_id])
  end
end
