class TagsController < ApplicationController
  def index
    @tags = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books
  end
end
