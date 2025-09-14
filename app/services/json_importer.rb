class JsonImporter
  attr_reader :data, :logs

  def initialize(json_data)
    @logs = []
    @data = if json_data.is_a?(String)
              JSON.parse(json_data)
            else
              json_data
            end

    raise ArgumentError, 'Invalid JSON format: Input must be a valid JSON hash' unless @data.is_a?(Hash)
  end

  def call
    process_restaurants_data(data)

    { success: true, logs: logs }
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parsing error: #{e.message}")
    logs << "Failed to parse JSON: #{e.message}"
    { success: false, logs: logs }
  rescue StandardError => e
    Rails.logger.error("Import error: #{e.message}")
    logs << "Unexpected error during import: #{e.message}"
    { success: false, logs: logs }
  end

  private

  def process_restaurants_data(data)
    restaurants_data = data['restaurants']
    raise 'Invalid JSON format: missing "restaurants" key' unless restaurants_data.is_a?(Array)

    restaurants_data.each do |restaurant_data|
      process_restaurant(restaurant_data)
    end
  end

  def process_restaurant(restaurant_data)
    restaurant_name = restaurant_data['name']
    raise 'Missing restaurant name' if restaurant_name.blank?

    restaurant = Restaurant.find_or_create_by(name: restaurant_name)
    logs << "Processing restaurant: #{restaurant_name}"

    menus_data = restaurant_data['menus']
    raise 'Missing menus for restaurant' unless menus_data.is_a?(Array)

    menus_data.each do |menu_data|
      process_menu(restaurant, menu_data)
    end
  rescue StandardError => e
    logs << "Error processing restaurant #{restaurant_name}: #{e.message}"
    Rails.logger.error("Error processing restaurant #{restaurant_name}: #{e.message}")
  end

  def process_menu(restaurant, menu_data)
    menu_name = menu_data['name']
    raise 'Missing menu name' if menu_name.blank?

    menu = restaurant.menus.find_or_create_by(name: menu_name)
    logs << "  Processing menu: #{menu_name} for #{restaurant.name}"

    items_data = menu_data['menu_items'] || menu_data['dishes']
    raise 'Missing menu items/dishes for menu' unless items_data.is_a?(Array)

    items_data.each do |item_data|
      process_menu_item(menu, item_data)
    end
  rescue StandardError => e
    logs << "  Error processing menu #{menu_name}: #{e.message}"
    Rails.logger.error("Error processing menu #{menu_name}: #{e.message}")
  end

  def process_menu_item(menu, item_data)
    item_name = item_data['name']&.strip
    price = item_data['price']

    if item_name.blank? || price.nil?
      logs << "    Skipping invalid item: name='#{item_name}', price=#{price}"
      return
    end

    begin
      menu_item = MenuItem.find_or_create_by!(name: item_name)

      if menu.menu_prices.exists?(menu_item: menu_item)
        logs << "    Item '#{item_name}' already exists in menu '#{menu.name}' - skipped (duplicate)"
        Rails.logger.warn("Duplicate item skipped: #{item_name} in #{menu.name}")
        return
      end

      menu_price = menu.menu_prices.build(menu_item: menu_item, price: price)
      raise "Validation failed: #{menu_price.errors.full_messages.join(', ')}" unless menu_price.save

      logs << "    Imported item '#{item_name}' (price: #{price}) to menu '#{menu.name}' - success"
    rescue ActiveRecord::RecordNotUnique
      logs << "    Item '#{item_name}' already exists in menu '#{menu.name}' - skipped (duplicate)"
      Rails.logger.warn("Duplicate item skipped: #{item_name} in #{menu.name}")
    rescue ActiveRecord::RecordInvalid => e
      logs << "    Failed to import item '#{item_name}': #{e.message}"
      Rails.logger.error("Validation error for item #{item_name}: #{e.message}")
    rescue StandardError => e
      logs << "    Failed to import item '#{item_name}': #{e.message}"
      Rails.logger.error("Error importing item #{item_name}: #{e.message}")
    end
  end
end
