require 'rails_helper'

RSpec.describe 'Menus API', openapi_spec: 'v1/swagger.json', type: :request do
  path '/api/restaurants/{restaurant_id}/menus' do
    get 'List all menus for a restaurant' do
      tags 'Menus'
      produces 'application/json'
      description 'Returns a list of menus for a specific restaurant'
      parameter name: :restaurant_id, in: :path, type: :integer, description: 'ID do restaurante', required: true

      response 200, 'successful' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Menu' }

        let(:restaurant) { create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let!(:menus) { create_list(:menu, 2, :with_menu_items, restaurant: restaurant) }

        after do |example|
          if response&.body
            example.metadata[:response][:content] = {
              'application/json' => {
                examples: { example: { value: JSON.parse(response.body, symbolize_names: true) } }
              }
            }
          end
        end

        run_test! do
          expect(response.body).to eq(MenuBlueprint.render(menus))
        end
      end

      response 404, 'restaurant not found' do
        schema '$ref' => '#/components/schemas/ErrorResponse'

        let(:restaurant_id) { 999 }

        run_test!
      end
    end
  end

  path '/api/restaurants/{restaurant_id}/menus/{id}' do
    get 'Get a specific menu' do
      tags 'Menus'
      produces 'application/json'
      description 'Returns details of a specific menu, including items'
      parameter name: :restaurant_id, in: :path, type: :integer, description: 'restaurant ID', required: true
      parameter name: :id, in: :path, type: :integer, description: 'menu ID', required: true

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/MenuWithItems'

        let(:restaurant) { create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:menu) { create(:menu, :with_menu_items, restaurant: restaurant) }
        let(:id) { menu.id }

        after do |example|
          if response&.body
            example.metadata[:response][:content] = {
              'application/json' => {
                examples: { example: { value: JSON.parse(response.body, symbolize_names: true) } }
              }
            }
          end
        end

        run_test! do
          expect(response.body).to eq(MenuBlueprint.render(menu, view: :menu_items))
        end
      end

      response 404, 'menu not found' do
        schema '$ref' => '#/components/schemas/ErrorResponse'

        let(:restaurant) { create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { 999 }

        run_test!
      end
    end
  end
end
