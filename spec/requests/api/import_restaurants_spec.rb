require 'rails_helper'

RSpec.describe 'Import Restaurants API', openapi_spec: 'v1/swagger.json', type: :request do
  path '/api/import_restaurants' do
    post 'Import restaurant data' do
      tags 'Imports'
      consumes 'application/json'
      produces 'application/json'
      description 'Imports restaurant data from a JSON payload, processing menus and items'

      parameter name: :import_data, in: :body, schema: { '$ref' => '#/components/schemas/ImportRequest' }

      response 200, 'successful' do
        schema '$ref' => '#/components/schemas/ImportResponse'

        let(:valid_payload) do
          {
            restaurants: [
              {
                name: 'API Test',
                menus: [
                  {
                    name: 'breakfast',
                    menu_items: [
                      { name: 'Pancakes', price: 7.0 }
                    ]
                  }
                ]
              }
            ]
          }.to_json
        end

        let(:import_data) { valid_payload }

        after do |example|
          if response&.body
            example.metadata[:response][:content] = {
              'application/json' => {
                examples: { example: { value: JSON.parse(response.body, symbolize_names: true) } }
              }
            }
          end
        end

        run_test!
      end

      response 400, 'bad request (invalid JSON)' do
        schema '$ref' => '#/components/schemas/ImportResponse'

        let(:import_data) { 'invalid' }

        run_test!
      end

      response 200, 'invalid data (missing restaurant name)' do
        schema '$ref' => '#/components/schemas/ImportResponse'

        let(:import_data) do
          { restaurants: [{ name: nil, menus: [] }] }.to_json
        end

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body, symbolize_names: true)).to include(
            success: true,
            logs: array_including(match(/Error processing restaurant : Missing restaurant name/))
          )
        end
      end
    end
  end
end
