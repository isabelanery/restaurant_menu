class MenuItemBlueprint < Blueprinter::Base
  fields :name

  view :details do
    fields :id
    fields :description
  end
end
