class AddColumnToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :status, :boolean, default: false
  end
end
