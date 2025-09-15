require 'rails_helper'

RSpec.describe 'Menu Items API', openapi_spec: 'v1/swagger.json', type: :request do
  path '/api/menu_items' do
    get 'List all menu items' do
      tags 'Menu Items'
      produces 'application/json'
      description 'Returns a list of all menu items'

      response 200, 'successful' do
        schema type: :array, items: { '$ref' => '#/components/schemas/MenuItem' }

        let!(:menu_items) { create_list(:menu_item, 2) }

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
          expect(response.body).to eq(MenuItemBlueprint.render(menu_items, view: :with_id))
        end
      end
    end
  end

  path '/api/menu_items/{id}' do
    get 'Get a specific menu item' do
      tags 'Menu Items'
      produces 'application/json'
      description 'Returns details of a specific menu item'
      parameter name: :id, in: :path, type: :integer, description: 'menu item ID', required: true

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/MenuItemDetails'

        let(:menu_item) { create(:menu_item) }
        let(:id) { menu_item.id }

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
          expect(response.body).to eq(MenuItemBlueprint.render(menu_item, view: :details))
        end
      end

      response 404, 'not found' do
        schema '$ref' => '#/components/schemas/ErrorResponse'

        let(:id) { 999 }

        run_test!
      end
    end
  end
end
