require 'rails_helper'

RSpec.describe JsonImporter do
  let(:valid_json) do
    {
      'restaurants' => [
        {
          'name' => 'Test Restaurant',
          'menus' => [
            {
              'name' => 'lunch',
              'menu_items' => [
                { 'name' => 'Burger', 'price' => 10.0 },
                { 'name' => 'Burger', 'price' => 10.0 }
              ]
            }
          ]
        }
      ]
    }
  end

  describe '#import' do
    context 'with valid data' do
      it 'imports successfully and logs actions' do
        importer = JsonImporter.new(valid_json)
        result = importer.call

        expect(result).to include_json(
          success: true,
          logs: be_an(Array)
        )
        expect(result[:logs].size).to be >= 3
        expect(result[:logs]).to include(match(/Processing restaurant: Test Restaurant/))
        expect(result[:logs]).to include(match(/Imported item 'Burger'/))
        expect(result[:logs]).to include(match(/already exists.*skipped/))
        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(1)
        expect(MenuItem.count).to eq(1)
        expect(MenuPrice.count).to eq(1)
      end
    end

    context 'with inconsistent key (dishes)' do
      let(:json_with_dishes) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => [
                {
                  'name' => 'dinner',
                  'dishes' => [
                    { 'name' => 'Salad', 'price' => 5.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'handles "dishes" key as fallback' do
        importer = JsonImporter.new(json_with_dishes)
        result = importer.call

        expect(result).to include_json(
          success: true,
          logs: be_an(Array)
        )
        expect(MenuItem.find_by(name: 'Salad')).to be_present
      end
    end

    context 'with invalid data' do
      it 'fails on malformed JSON' do
        expect do
          JsonImporter.new('invalid').import
        end.to raise_error(JSON::ParserError)
      end
    end
  end
end
