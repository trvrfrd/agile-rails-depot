class StoreController < ApplicationController
  def index
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    @products = Product.order(:title)
  end
end
