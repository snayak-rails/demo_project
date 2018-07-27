class User < ApplicationRecord
  has_many :carts
  has_many :products

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :contact, numericality: true, length: { minimum: 12 }
  validates :password_digest, presence: true, length: { minimum: 3}

  has_secure_password
end
