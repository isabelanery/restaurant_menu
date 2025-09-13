FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "#{Faker::Food.dish} #{n}" }
    description { Faker::Food.description }

    factory :menu_item_with_price, parent: :menu_item do
      after(:create) do |menu_item, evaluator|
        create(:menu_price, menu: evaluator.menu, menu_item: menu_item)
      end
    end
  end
end
