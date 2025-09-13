class RestaurantBlueprint < Blueprinter::Base
  identifier :id
  fields :name

  view :detailed do
    association :menus, blueprint: MenuBlueprint, view: :menu_items
  end
end
