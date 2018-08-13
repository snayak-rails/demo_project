# frozen_string_literal: true

# model for user
class User < ApplicationRecord
  has_many :carts
  has_many :products

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :contact, numericality: true, length: { minimum: 10 }
  validates :password, presence: true, length: { minimum: 6 }
  validates_confirmation_of :password

  has_secure_password
end
