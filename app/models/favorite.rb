class Favorite < ApplicationRecord
  belongs_to :user
  bslongs_to :restaurant
end
