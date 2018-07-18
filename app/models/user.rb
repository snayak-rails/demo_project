class User < ApplicationRecord
  has_many :carts
  has_many :products

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :contact, numericality: true
  validates :password_digest, presence: true

  has_secure_password
end
