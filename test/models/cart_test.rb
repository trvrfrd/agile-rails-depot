require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:one)
    @product = products(:ruby)
  end

  test '#add_product adds a product via line_items' do
    assert_difference('@cart.line_items.size', 1) do
      @cart.add_product(@product)
    end
    assert_equal @product, @cart.line_items.last.product
  end

  test '#add_product copies product price to line item' do
    line_item = @cart.add_product(@product)
    assert_equal @product.price, line_item.price
  end

  test '#add_product updates quantity for duplicate items' do
    line_item = @cart.add_product(@product)
    assert_equal 1, line_item.quantity
    assert_equal @product, line_item.product
    # this is smelly, should #add_product itself do the saving?
    @cart.save!
    line_item = @cart.add_product(@product)
    assert_equal 2, line_item.quantity
    assert_equal @product, line_item.product
  end

  test '#total_price sums line item prices' do
    assert_equal products(:one).price, @cart.total_price
    @cart.line_items.create!(product: products(:two))
    assert_equal products(:one).price + products(:two).price, @cart.total_price
  end
end
