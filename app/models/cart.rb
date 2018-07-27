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
end
