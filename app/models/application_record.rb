# frozen_string_literal: true

# methods for use in model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # returns hash for a given string
  def self.digest(string)
    minimum_cost = BCrypt::Engine::MIN_COST
    normal_cost = BCrypt::Engine.cost
    cost = ActiveModel::SecurePassword.min_cost ? minimum_cost : normal_cost
    BCrypt::Password.create(string, cost: cost)
  end

  # returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
