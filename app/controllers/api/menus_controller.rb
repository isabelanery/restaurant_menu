module Api
  class MenusController < ApplicationController
    def index
      @menus = Menu.all
      render json: MenuBlueprint.render(@menus)
    end

    def show
      @menu = Menu.find(params[:id])
      render json: MenuBlueprint.render(@menu)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu not found' }, status: :not_found
    end
  end
end
