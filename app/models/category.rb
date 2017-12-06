class Category < ApplicationRecord
  has_many :restaurants, dependent: :destroy
end
