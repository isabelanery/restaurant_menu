require 'factory_bot_rails'

Restaurant.destroy_all
Menu.destroy_all
MenuItem.destroy_all
MenuPrice.destroy_all

global_menu_items = [
  FactoryBot.create(:menu_item, name: "#{Faker::JapaneseMedia::OnePiece.character} Burger",
                                description: 'Classic beef burger'),
  FactoryBot.create(:menu_item, name: "#{Faker::JapaneseMedia::OnePiece.character} Pizza",
                                description: 'Margherita pizza'),
  FactoryBot.create(:menu_item, name: "#{Faker::JapaneseMedia::OnePiece.character} Salad",
                                description: 'Fresh garden salad')
]

restaurant1 = FactoryBot.create(:restaurant)

menu1 = FactoryBot.create(:menu, restaurant: restaurant1)
menu2 = FactoryBot.create(:menu, restaurant: restaurant1)

FactoryBot.create(:menu_price, menu: menu1, menu_item: global_menu_items[0], price: 10.00)
FactoryBot.create(:menu_price, menu: menu2, menu_item: global_menu_items[0], price: 15.00)

FactoryBot.create(:menu_price, menu: menu1, menu_item: global_menu_items[1], price: 12.00)
FactoryBot.create(:menu_price, menu: menu2, menu_item: global_menu_items[2], price: 8.00)

restaurant2 = FactoryBot.create(:restaurant)

menu3 = FactoryBot.create(:menu, restaurant: restaurant2)
menu4 = FactoryBot.create(:menu, restaurant: restaurant2)

FactoryBot.create(:menu_price, menu: menu3, menu_item: global_menu_items[0], price: 11.00)
FactoryBot.create(:menu_price, menu: menu4, menu_item: global_menu_items[0], price: 11.00)

FactoryBot.create(:menu_price, menu: menu3, menu_item: global_menu_items[1], price: 13.00)
FactoryBot.create(:menu_price, menu: menu4, menu_item: global_menu_items[2], price: 9.00)
