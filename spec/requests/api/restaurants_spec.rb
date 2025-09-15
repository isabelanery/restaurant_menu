require 'rails_helper'

RSpec.describe 'Restaurants API', openapi_spec: 'v1/swagger.json', type: :request do
  path '/api/restaurants' do
    get 'List all restaurants' do
      tags 'Restaurants'
      produces 'application/json'
      description 'Returns a list of all restaurants with menu details'

      response 200, 'successful' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Restaurant' }

        let!(:restaurants) { create_list(:restaurant, 2, :with_menus) }

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
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(RestaurantBlueprint.render(restaurants, view: :detailed))
        end
      end
    end
  end

  path '/api/restaurants/{id}' do
    get 'Get a specific restaurant' do
      tags 'Restaurants'
      produces 'application/json'
      description 'Returns details for a specific restaurant, including menus'
      parameter name: :id, in: :path, type: :integer, description: 'ID do restaurante', required: true

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/Restaurant'

        let(:restaurant) { create(:restaurant) }
        let(:id) { restaurant.id }

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
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(RestaurantBlueprint.render(restaurant, view: :detailed))
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
