module Api
  class MenusController < ApplicationController
    before_action :set_restaurant

    def index
      render json: MenuBlueprint.render(@restaurant.menus)
    end

    def show
      menu = @restaurant.menus.find(params[:id])
      render json: MenuBlueprint.render(menu, view: :menu_items)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu not found' }, status: :not_found
    end

    private

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Restaurant not found' }, status: :not_found
    end
  end
end
