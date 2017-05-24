class CombineItemsInCart < ActiveRecord::Migration[5.0]
  def up
    # Replaces duplicate line items for a single product in a cart with a single
    # line item
    Cart.all.each do |cart|
      sums = cart.line_items.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        next unless quantity > 1
        cart.line_items.where(product_id: product_id).delete_all
        cart.line_items.create!(product_id: product_id, quantity: quantity)
      end
    end
  end

  def down
    # Splits line items with quantity > 1 into multiple new line items
    LineItem.where('quantity > 1').each do |item|
      item.quantity.times do
        LineItem.create(
          cart_id: item.cart_id,
          product_id: item.product_id,
          quantity: 1
        )
      end
      item.destroy
    end
  end
end
