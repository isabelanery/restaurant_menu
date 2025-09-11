require 'rails_helper'

RSpec.describe Api::MenusController, type: :controller do
  describe 'GET #index' do
    let!(:menus) { create_list(:menu, 2, :with_menu_items) }

    before { get :index }
    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all menus in JSON format' do
      expect(response.parsed_body).to include_json(
        menus.map do |menu|
          {
            id: menu.id,
            name: menu.name,
            description: menu.description,
            menu_items: menu.menu_items.map do |item|
              { id: item.id, name: item.name, price: item.price.to_s }
            end
          }
        end
      )
    end

    it 'renders menus using MenuBlueprint' do
      expect(response.body).to eq(MenuBlueprint.render(menus))
    end
  end

  describe 'GET #show' do
    let(:menu) { create(:menu, :with_menu_items) }

    context 'when menu exists' do
      before { get :show, params: { id: menu.id } }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the menu in JSON format' do
        expect(response.parsed_body).to include_json(
          id: menu.id,
          name: menu.name,
          description: menu.description,
          menu_items: menu.menu_items.map do |item|
            { id: item.id, name: item.name, price: item.price.to_s }
          end
        )
      end

      it 'renders menu using MenuBlueprint' do
        expect(response.body).to eq(MenuBlueprint.render(menu))
      end
    end

    context 'when menu does not exist' do
      before { get :show, params: { id: 999 } }

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
