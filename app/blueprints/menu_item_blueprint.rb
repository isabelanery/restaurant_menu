class MenuItemBlueprint < Blueprinter::Base
  fields :name

  view :with_id do
    fields :id
  end

  view :details do
    include_view :with_id
    fields :description
  end
end
