class MovePriceToMenuPrices < ActiveRecord::Migration[8.0]
  def up
    add_column :menu_prices, :price, :decimal, precision: 5, scale: 2, null: false, default: 0.00
    remove_column :menu_items, :price
  end

  def down
    add_column :menu_items, :price, :decimal, precision: 5, scale: 2
    remove_column :menu_prices, :price
  end
end
