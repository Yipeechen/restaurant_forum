class AddFavoritesCountToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :favorites_count, :integer, default: 0
  end
end
