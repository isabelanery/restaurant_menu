FactoryBot.define do
  factory :menu_price do
    menu
    menu_item
    price { Faker::Commerce.price(range: 5.0..50.0) }
  end
end
