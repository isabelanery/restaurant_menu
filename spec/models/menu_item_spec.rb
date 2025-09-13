require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'validations' do
    subject { build(:menu_item) }

    describe 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).case_insensitive }

      context 'when name is invalid' do
        it 'is not valid with a blank name' do
          menu_item = build(:menu_item, name: '')
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:name]).to include("can't be blank")
        end

        it 'is not valid with a name containing only spaces' do
          menu_item = build(:menu_item, name: '   ')
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:name]).to include("can't be blank")
        end
      end

      context 'when name is valid' do
        it 'is valid with a valid name' do
          menu_item = build(:menu_item, name: 'Main Dish')
          expect(menu_item).to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { should have_many(:menus).through(:menu_prices) }
  end

  describe 'global uniqueness' do
    it 'prevents duplicate names' do
      create(:menu_item, name: 'Burger')
      duplicate = build(:menu_item, name: 'Burger')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include('has already been taken')
    end

    it 'prevents duplicate names case-insensitively' do
      create(:menu_item, name: 'Burger')
      duplicate = build(:menu_item, name: 'burger')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include('has already been taken')
    end
  end

  describe 'multiple menus with different prices' do
    let(:restaurant) { create(:restaurant) }
    let(:menu1) { create(:menu, restaurant: restaurant) }
    let(:menu2) { create(:menu, restaurant: restaurant) }
    let(:menu_item) { create(:menu_item) }

    it 'can be on multiple menus with different prices' do
      create(:menu_price, menu: menu1, menu_item: menu_item, price: 10.00)
      create(:menu_price, menu: menu2, menu_item: menu_item, price: 12.00)
      expect(menu_item.menus).to include(menu1, menu2)
      expect(menu_item.menu_prices.find_by(menu: menu1).price).to eq(10.00)
      expect(menu_item.menu_prices.find_by(menu: menu2).price).to eq(12.00)
    end
  end
end
