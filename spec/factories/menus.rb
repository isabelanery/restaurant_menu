FactoryBot.define do
  factory :menu do
    name { Faker::JapaneseMedia::OnePiece.character }
    description { Faker::Lorem.sentence }

    trait :with_menu_items do
      after(:create) do |menu|
        create_list(:menu_item, 1, menu: menu)
      end
    end
  end
end
