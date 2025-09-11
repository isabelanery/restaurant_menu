# db/seeds.rb
require 'factory_bot_rails'

MenuItem.destroy_all
Menu.destroy_all

5.times do
  FactoryBot.create(:menu, :with_menu_items)
end

menu = FactoryBot.create(:menu, name: 'Special Dinner Menu', description: 'A curated selection of gourmet dishes')
FactoryBot.create(:menu_item, menu: menu, name: 'Grilled Salmon', price: 24.99)
FactoryBot.create(:menu_item, menu: menu, name: 'Truffle Risotto', price: 19.99)
FactoryBot.create(:menu_item, menu: menu, name: 'Chocolate Lava Cake', price: 8.99)
