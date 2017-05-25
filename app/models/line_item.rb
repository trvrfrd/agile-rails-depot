class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  # New LineItems are mostly created via Cart#add_product, which also sets the
  # price from the associated Product. This is just an extra line of defense.
  before_validation :set_price_from_product, on: :create
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  def total_price
    price * quantity
  end

  private

  def set_price_from_product
    self.price = product.price
  end
end
