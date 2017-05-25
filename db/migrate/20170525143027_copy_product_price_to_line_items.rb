class CopyProductPriceToLineItems < ActiveRecord::Migration[5.0]
  def up
    LineItem.all.each do |item|
      next if item.price
      item.update_attributes!(price: item.product.price)
    end
  end

  def down
    LineItem.update_all(price: nil)
  end
end
