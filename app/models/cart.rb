class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_or_initialize_by(product_id: product.id)
    # this won't work properly when calling multiples times without saving the
    # cart in between calls. is that bad?
    current_item.quantity += 1 unless current_item.new_record? # default = 1
    current_item.price = product.price
    current_item
  end

  def total_price
    line_items.to_a.sum(&:total_price)
  end
end
