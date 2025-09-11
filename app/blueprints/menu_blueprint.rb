class MenuBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description
  association :menu_items, blueprint: MenuItemBlueprint
end
