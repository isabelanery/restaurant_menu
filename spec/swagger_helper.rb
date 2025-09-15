require 'fileutils'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s
  config.openapi_format = :json

  FileUtils.mkdir_p(File.join(config.openapi_root, 'v1'))

  config.openapi_specs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Restaurant Menu API',
        version: 'v1',
        description: 'API for managing restaurants, menus, and menu items. Supports JSON data import.'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Local development server'
        }
      ],
      components: {
        schemas: {
          Restaurant: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              menus: {
                type: :array,
                items: { '$ref' => '#/components/schemas/MenuWithItems' }
              }
            },
            required: %w[id name]
          },
          Menu: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string }
            },
            required: %w[id name]
          },
          MenuWithItems: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              menu_items: {
                type: :array,
                items: { '$ref' => '#/components/schemas/MenuItemWithPrice' }
              }
            },
            required: %w[id name]
          },
          MenuItem: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string }
            },
            required: %w[name]
          },
          MenuItemDetails: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string, nullable: true }
            },
            required: %w[id name]
          },
          MenuItemWithPrice: {
            type: :object,
            properties: {
              name: { type: :string },
              price: { type: :string }
            },
            required: %w[name price]
          },
          ImportRequest: {
            type: :object,
            properties: {
              restaurants: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    menus: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          name: { type: :string },
                          menu_items: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                name: { type: :string },
                                price: { type: :number, format: :float }
                              },
                              required: %w[name price]
                            }
                          }
                        },
                        required: %w[name menu_items]
                      }
                    }
                  },
                  required: %w[name menus]
                }
              }
            },
            required: %w[restaurants]
          },
          ImportResponse: {
            type: :object,
            properties: {
              success: { type: :boolean },
              logs: { type: :array, items: { type: :string } }
            },
            required: %w[success logs]
          },
          ErrorResponse: {
            type: :object,
            properties: {
              error: { type: :string }
            },
            required: %w[error]
          }
        }
      }
    }
  }

  config.after(:suite) do
    config.openapi_specs.each do |path, spec|
      full_path = File.join(config.openapi_root, path)
      File.write(full_path, JSON.pretty_generate(spec))
    end
  end
end
