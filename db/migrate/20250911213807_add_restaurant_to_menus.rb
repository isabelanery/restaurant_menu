class AddRestaurantToMenus < ActiveRecord::Migration[8.0]
  def change
    add_column :menus, :restaurant_id, :integer
    add_foreign_key :menus, :restaurants
    add_index :menus, :restaurant_id
  end
end
