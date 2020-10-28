class TagsController < ApplicationController
  def index
    @tags = Tag.all.order('created_at DESC')
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books
  end
end
