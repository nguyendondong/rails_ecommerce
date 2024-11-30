class Category < ApplicationRecord
  RANSACABLE_ATTRIBUTES = %w(id name)

  has_many :products, dependent: :destroy
end
