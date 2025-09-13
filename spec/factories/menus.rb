FactoryBot.define do
  factory :menu do
    restaurant
    name { "#{Faker::JapaneseMedia::OnePiece.akuma_no_mi} #{Faker::Restaurant.type}" }

    trait :with_menu_items do
      after(:create) do |menu|
        menu_items = create_list(:menu_item, 2)
        menu_items.each do |item|
          create(:menu_price, menu: menu, menu_item: item, price: Faker::Commerce.price(range: 5.00..99.99))
        end
      end
    end
  end
end
