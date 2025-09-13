class MenuPriceBlueprint < Blueprinter::Base
  fields :price

  view :menu_item do
    field(:name) { |menu_price| menu_price.menu_item.name }
  end
end
