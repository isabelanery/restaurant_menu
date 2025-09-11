require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'validations' do
    describe 'name' do
      it { should validate_presence_of(:name) }

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

    describe 'price' do
      it { should validate_presence_of(:price) }
      it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

      context 'when price is invalid' do
        it 'is not valid with a nil price' do
          menu_item = build(:menu_item, price: nil)
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:price]).to include("can't be blank")
        end

        it 'is not valid with a negative price' do
          menu_item = build(:menu_item, price: -1)
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:price]).to include('must be greater than or equal to 0')
        end
      end

      context 'when price is valid' do
        it 'is valid with a price of zero' do
          menu_item = build(:menu_item, price: 0)
          expect(menu_item).to be_valid
        end

        it 'is valid with a positive price' do
          menu_item = build(:menu_item, price: 10.99)
          expect(menu_item).to be_valid
        end
      end
    end

    describe 'menu association' do
      it 'is not valid without a menu' do
        menu_item = build(:menu_item, menu: nil)
        expect(menu_item).not_to be_valid
        expect(menu_item.errors[:menu]).to include('must exist')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:menu) }
  end
end
