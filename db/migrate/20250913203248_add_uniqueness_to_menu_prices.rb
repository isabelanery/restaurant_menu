class AddUniquenessToMenuPrices < ActiveRecord::Migration[8.0]
  def change
    remove_index :menu_prices, %i[menu_id menu_item_id] if index_exists?(:menu_prices, %i[menu_id menu_item_id])

    add_index :menu_prices, %i[menu_id menu_item_id], unique: true
  end
end
