# frozen_string_literal: true

# methods for use in model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
