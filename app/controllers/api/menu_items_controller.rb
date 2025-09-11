module Api
  class MenuItemsController < ApplicationController
    before_action :set_menu

    def index
      render json: MenuItemBlueprint.render(@menu.menu_items)
    end

    def show
      @menu_item = @menu.menu_items.find(params[:id])
      render json: MenuItemBlueprint.render(@menu_item)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu item not found' }, status: :not_found
    end

    private

    def set_menu
      @menu = Menu.find(params[:menu_id])
    end
  end
end
