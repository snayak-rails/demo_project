# frozen_string_literal: true

# model for user
class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :carts
  has_many :products

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :contact, numericality: true, length: { minimum: 12 }
  validates :password_digest, presence: true, length: { minimum: 3 }

  has_secure_password

  def remember
    self.remember_token = ApplicationRecord.new_token
    update_attribute(:remember_digest, ApplicationRecord.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
