module Api
  class RestaurantsController < ApplicationController
    def index
      restaurants = Restaurant.all
      render json: RestaurantBlueprint.render(restaurants, view: :detailed)
    end

    def show
      restaurant = Restaurant.find(params[:id])
      render json: RestaurantBlueprint.render(restaurant, view: :detailed)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Restaurant not found' }, status: :not_found
    end
  end
end
