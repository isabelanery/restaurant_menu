class RenameMenuMenuItemsToMenuPrices < ActiveRecord::Migration[8.0]
  def change
    rename_table :menu_menu_items, :menu_prices
  end
end
