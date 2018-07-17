class User < ApplicationRecord
  has_many :carts
  has_many :products

  validates :name, presence: true
  validates :email, presence: true

  has_secure_password
end
