require 'rails_helper'

RSpec.describe Api::RestaurantsController, type: :controller do
  describe 'GET #index' do
    let!(:restaurants) { create_list(:restaurant, 2, :with_menus) }

    before { get :index }

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all restaurants in JSON format' do
      expect(response.parsed_body).to include_json(
        restaurants.map do |restaurant|
          {
            id: restaurant.id,
            name: restaurant.name
          }
        end
      )
    end

    it 'renders restaurants using RestaurantBlueprint' do
      expect(response.body).to eq(RestaurantBlueprint.render(restaurants, view: :detailed))
    end
  end

  describe 'GET #show' do
    context 'when restaurant exists' do
      let(:restaurant) { create(:restaurant) }

      before { get :show, params: { id: restaurant.id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the restaurant in JSON format' do
        expect(response.parsed_body).to include_json(
          id: restaurant.id,
          name: restaurant.name
        )
      end

      it 'renders restaurant using RestaurantBlueprint' do
        expect(response.body).to eq(RestaurantBlueprint.render(restaurant, view: :detailed))
      end
    end

    context 'when restaurant does not exist' do
      before { get :show, params: { id: 999 } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(response.parsed_body).to include_json(
          error: 'Restaurant not found'
        )
      end
    end
  end
end
