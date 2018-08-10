# frozen_string_literal: true

# Model for cart
class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :contact, presence: true, numericality: true, length: { minimum: 10 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address1, presence: true
  validates :city, presence: true, length: { maximum: 25 }
  validates :state, presence: true, length: { maximum: 20 }
  validates :country, presence: true, length: { maximum: 20 }
  validates :pincode, presence: true, numericality: true, length: { maximum: 10 }

  def total_amount(total_amount = 0)
    cart_items.all.each do |cart_item|
      quantity = cart_item.quantity
      if cart_item.price.blank?
        product = Product.find(cart_item.product_id)
        total_amount += product.price * quantity
      else
        total_amount += cart_item.price * quantity
      end
    end
    total_amount.round(2)
  end

  def update_cart_items
    cart_items.all.each do |cart_item|
      product = Product.find(cart_item.product_id)
      reduced_stock = product.stock - cart_item.quantity
      product.update(stock: reduced_stock)
      cart_item.update(title: product.title, price: product.price)
    end
  end

  def destroy_cart_items_for_nil_product
    cart_items.all.each do |cart_item|
      CartItem.destroy(cart_item.id) unless Product.exists?(id: cart_item.product_id)
    end
  end

  def self.merged_cart(user_cart, temp_cart)
    temp_cart.cart_items.all.each do |cart_item|
      same_item = user_cart.cart_items.find_by_product_id(cart_item.product_id)
      if same_item.blank?
        cart_item.update(cart_id: user_cart.id)
      else
        new_quantity = cart_item.quantity + same_item.quantity
        same_item.update(quantity: new_quantity)
      end
    end
    Cart.destroy(temp_cart.id)
    user_cart
  end
end
