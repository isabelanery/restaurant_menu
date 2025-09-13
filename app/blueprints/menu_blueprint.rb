class MenuBlueprint < Blueprinter::Base
  identifier :id

  fields :name

  view :menu_items do
    association :menu_prices, blueprint: MenuPriceBlueprint, view: :menu_item, name: :menu_items
  end
end
