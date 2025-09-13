require 'rails_helper'

RSpec.describe Api::MenusController, type: :controller do
  describe 'GET #index' do
    let(:restaurant) { create(:restaurant) }
    let!(:menus) { create_list(:menu, 2, :with_menu_items, restaurant: restaurant) }

    before { get :index, params: { restaurant_id: restaurant.id } }

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all menus for the specific restaurant in JSON format' do
      expect(response.parsed_body).to include_json(
        menus.map do |menu|
          {
            id: menu.id,
            name: menu.name
          }
        end
      )
    end

    it 'renders menus using MenuBlueprint' do
      expect(response.body).to eq(MenuBlueprint.render(menus))
    end

    context 'when restaurant does not exist' do
      before { get :index, params: { restaurant_id: 999 } }

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

  describe 'GET #show' do
    context 'when menu exists' do
      let(:restaurant) { create(:restaurant) }
      let(:menu) { create(:menu, :with_menu_items, restaurant: restaurant) }

      before { get :show, params: { restaurant_id: restaurant.id, id: menu.id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the menu with its items in JSON format' do
        menu_items = menu.menu_prices.map do |menu_price|
          {
            name: menu_price.menu_item.name,
            price: menu_price.price.to_s
          }
        end

        expect(response.parsed_body).to include_json(
          id: menu.id,
          name: menu.name,
          menu_items: menu_items
        )
      end

      it 'renders menu with menu items using MenuBlueprint' do
        expect(response.body).to eq(MenuBlueprint.render(menu, view: :menu_items))
      end
    end

    context 'when menu does not exist' do
      let(:restaurant) { create(:restaurant) }
      before { get :show, params: { restaurant_id: restaurant.id, id: 999 } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(response.parsed_body).to include_json(
          error: 'Menu not found'
        )
      end
    end
  end
end
