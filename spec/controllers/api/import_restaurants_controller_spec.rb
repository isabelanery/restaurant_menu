require 'rails_helper'

RSpec.describe Api::ImportRestaurantsController, type: :controller do
  describe 'POST #create' do
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

    context 'with valid JSON data' do
      before do
        request.headers['CONTENT_TYPE'] = 'application/json'
        post :create, params: {}, body: valid_payload, as: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success and logs in JSON format' do
        expect(response.parsed_body).to include_json(
          success: true,
          logs: be_an(Array)
        )
        expect(response.parsed_body['logs']).to include(match(/Imported item 'Pancakes'/))
      end
    end

    context 'with invalid JSON' do
      before do
        request.headers['CONTENT_TYPE'] = 'application/json'
        post :create, params: {}, body: 'invalid', as: :json
      end

      it 'returns a bad request response' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns failure and error message' do
        expect(response.parsed_body).to include_json(
          success: false,
          logs: be_an(Array)
        )
        expect(response.parsed_body['logs']).to include(match(/Invalid JSON/))
      end
    end
  end
end
