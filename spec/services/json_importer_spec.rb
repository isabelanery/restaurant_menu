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

  describe '#call' do
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
          JsonImporter.new('invalid').call
        end.to raise_error(JSON::ParserError)
      end
    end

    context 'with JSON missing restaurants key' do
      let(:invalid_json) { {} }

      it 'fails and logs missing restaurants key' do
        importer = JsonImporter.new(invalid_json)
        result = importer.call

        expect(result).to include(
          success: false,
          logs: include(match(/Invalid JSON format: missing "restaurants" key/))
        )
      end
    end

    context 'with restaurant missing name' do
      let(:json_no_name) do
        {
          'restaurants' => [
            {
              'name' => '',
              'menus' => [
                { 'name' => 'lunch', 'menu_items' => [{ 'name' => 'Burger', 'price' => 10.0 }] }
              ]
            }
          ]
        }
      end

      it 'logs error for missing restaurant name' do
        importer = JsonImporter.new(json_no_name)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(/Error processing restaurant\s*:\s*Missing restaurant name/))
        )
        expect(Restaurant.count).to eq(0)
      end
    end

    context 'with menus not an array' do
      let(:json_invalid_menus) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => {}
            }
          ]
        }
      end

      it 'logs error for invalid menus format' do
        importer = JsonImporter.new(json_invalid_menus)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(/Error processing restaurant Test Restaurant: Missing menus for restaurant/))
        )
        expect(Menu.count).to eq(0)
      end
    end

    context 'with menu missing name' do
      let(:json_no_menu_name) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => [
                { 'name' => '', 'menu_items' => [{ 'name' => 'Burger', 'price' => 10.0 }] }
              ]
            }
          ]
        }
      end

      it 'logs error for missing menu name' do
        importer = JsonImporter.new(json_no_menu_name)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(/Error processing menu\s*:\s*Missing menu name/))
        )
        expect(Menu.count).to eq(0)
      end
    end

    context 'with menu items not an array' do
      let(:json_invalid_items) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => [
                { 'name' => 'lunch', 'menu_items' => {} }
              ]
            }
          ]
        }
      end

      it 'logs error for invalid menu items format' do
        importer = JsonImporter.new(json_invalid_items)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(%r{Error processing menu lunch: Missing menu items/dishes for menu}))
        )
        expect(MenuItem.count).to eq(0)
      end
    end

    context 'with invalid menu item data' do
      let(:json_invalid_item) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => [
                {
                  'name' => 'lunch',
                  'menu_items' => [
                    { 'name' => '', 'price' => 10.0 },
                    { 'name' => 'Burger', 'price' => nil }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'skips items with missing name or price and logs' do
        importer = JsonImporter.new(json_invalid_item)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(/Skipping invalid item: name='', price=10.0/))
        )
        expect(MenuItem.count).to eq(0)
      end
    end

    context 'with validation error on menu price' do
      let(:json_with_invalid_price) do
        {
          'restaurants' => [
            {
              'name' => 'Test Restaurant',
              'menus' => [
                {
                  'name' => 'lunch',
                  'menu_items' => [
                    { 'name' => 'Burger', 'price' => -10.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      before do
        allow_any_instance_of(MenuPrice).to receive(:save).and_return(false)
        allow_any_instance_of(MenuPrice).to receive(:errors).and_return(
          double(full_messages: ['Price must be greater than 0'])
        )
      end

      it 'logs validation error for menu price' do
        importer = JsonImporter.new(json_with_invalid_price)
        result = importer.call

        expect(result).to include(
          success: true,
          logs: include(match(/Failed to import item 'Burger': Validation failed: Price must be greater than 0/))
        )
        expect(MenuPrice.count).to eq(0)
      end
    end
  end
end
