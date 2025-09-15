module Api
  class MenuItemsController < ApplicationController
    def index
      menu_items = MenuItem.all
      render json: MenuItemBlueprint.render(menu_items, view: :with_id)
    end

    def show
      menu_item = MenuItem.find(params[:id])
      render json: MenuItemBlueprint.render(menu_item, view: :details)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu item not found' }, status: :not_found
    end
  end
end
