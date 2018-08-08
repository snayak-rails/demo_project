# frozen_string_literal:true

# methods to check for stock avaibility of products
module Buyable
  extend ActiveSupport::Concern

  def check_stock
    product = Product.find(params[:product_id])
    return if product.stock >= 1
    flash_ajax_message('Item out of stock')
  end

  def check_stock_for_cart_items
    @cart.cart_items.all.each do |cart_item|
      product = Product.find(cart_item.product_id)
      next if cart_item.quantity <= product.stock
      message = 'Product: ' + product.title +
                ' has ' + product.stock.to_s + ' pieces available '
      flash_ajax_message(message)
      break
    end
  end
end
