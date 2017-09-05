class StoreController < ApplicationController
  include CurrentCart

  skip_before_action :authorize
  before_action :set_cart

  def index
    redirect_to store_index_url(locale: params[:set_locale]) and return if params[:set_locale]
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    @products = Product.where(locale: I18n.locale).order(:title)
  end
end
