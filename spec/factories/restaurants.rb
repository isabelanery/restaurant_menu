FactoryBot.define do
  factory :restaurant do
    name { "#{Faker::JapaneseMedia::OnePiece.island} - #{Faker::Restaurant.name}" }

    trait :with_menus do
      after(:create) do |restaurant|
        create_list(:menu, 2, :with_menu_items, restaurant: restaurant)
      end
    end
  end
end
