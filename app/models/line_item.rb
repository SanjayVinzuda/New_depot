class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :cart
  belongs_to :product

  def total_price
    # @line_items.to_a.each(&:total_price).sum
    product.price * quantity
  end

end
