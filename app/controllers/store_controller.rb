class StoreController < ApplicationController
  include CurrentCart

  skip_before_action :authorize
  before_action :set_cart

  def index
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    @products = Product.order(:title)
  end
end
