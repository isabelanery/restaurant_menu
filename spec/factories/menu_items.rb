FactoryBot.define do
  factory :menu_item do
    menu
    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 5.0..50.0) }
    description { Faker::Food.description }
  end
end
