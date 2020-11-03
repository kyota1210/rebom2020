class SalesController < ApplicationController

  def new
    @book = Book.find(params[:id])
    
    @sale = Sale.new
  end
end
