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

  def total_amount
    total_amount = 0
    cart_items.each do |cart_item|
      quantity = cart_item.quantity
      product = Product.find(cart_item.product_id) if cart_item.price.nil?
      total_amount += product.price * quantity if cart_item.price.nil?
      total_amount += cart_item.price * quantity unless cart_item.price.nil?
    end
    total_amount.round(2)
  end

  def destroy_cart_items_for_nil_product
    cart_items.each do |cart_item|
      cart_item.destroy unless Product.exists?(id: cart_item.product_id)
    end
  end
end
