class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  enum pay_type: {
    'Check'          => 0,
    'Credit card'    => 1,
    'Purchase order' => 2
  }

  validates :name, :address, :email, :line_items, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil # prevent dependent: destroy when cart destroyed
      line_items << item
    end
  end

  def total_price
    line_items.to_a.sum(&:total_price)
  end
end
