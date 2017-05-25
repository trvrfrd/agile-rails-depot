require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  setup { @line_item = line_items(:one) }

  test 'sets price from product by default on create' do
    item = LineItem.create!(product: products(:one), cart: carts(:one))
    assert_equal products(:one).price, item.price
  end

  test '#total_price accounts for price and quantity' do
    @line_item.quantity = 99
    assert_equal 99 * @line_item.price, @line_item.total_price
  end

  test '#total_price uses line item price rather than product price' do
    @line_item.price = 666.00
    assert_equal @line_item.price, @line_item.total_price
    assert_not_equal @line_item.product.price, @line_item.total_price
  end
end
