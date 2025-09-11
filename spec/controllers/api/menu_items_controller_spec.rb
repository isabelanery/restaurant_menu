require 'rails_helper'

RSpec.describe Api::MenuItemsController, type: :controller do
  describe 'GET #index' do
    let(:menu) { create(:menu) }
    let!(:menu_items) { create_list(:menu_item, 2, menu: menu) }

    before { get :index, params: { menu_id: menu.id } }

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all menu items in JSON format' do
      expect(response.parsed_body).to include_json(
        menu_items.map do |item|
          {
            id: item.id,
            name: item.name,
            price: item.price.to_s,
            description: item.description
          }
        end
      )
    end

    it 'renders menu items using MenuItemBlueprint' do
      expect(response.body).to eq(MenuItemBlueprint.render(menu_items))
    end
  end

  describe 'GET #show' do
    let(:menu) { create(:menu) }
    let(:menu_item) { create(:menu_item, menu: menu) }

    context 'when menu item exists' do
      before { get :show, params: { menu_id: menu.id, id: menu_item.id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the menu item in JSON format' do
        expect(response.parsed_body).to include_json(
          id: menu_item.id,
          name: menu_item.name,
          price: menu_item.price.to_s,
          description: menu_item.description
        )
      end

      it 'renders menu item using MenuItemBlueprint' do
        expect(response.body).to eq(MenuItemBlueprint.render(menu_item))
      end
    end

    context 'when menu item does not exist' do
      before { get :show, params: { menu_id: menu.id, id: 999 } }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(response.parsed_body).to include_json(
          error: 'Menu item not found'
        )
      end
    end
  end
end
