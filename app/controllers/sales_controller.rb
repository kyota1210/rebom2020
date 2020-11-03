class SalesController < ApplicationController
before_action :authenticate_user!, only: [:new]

  def new
    @book = Book.find(params[:id])
    @sale = Sale.new
  end
end
