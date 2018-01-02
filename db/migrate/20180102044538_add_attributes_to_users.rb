class AddAttributesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :intro, :text
    add_column :users, :avatar, :string
  end
end
