require 'rails_helper'

RSpec.describe MenuPrice, type: :model do
  let!(:menu) { create(:menu) }
  let!(:menu_item) { create(:menu_item) }

  describe 'validations' do
    describe 'price' do
      subject { build(:menu_price, menu: menu, menu_item: menu_item) }

      it { should validate_presence_of(:price) }
      it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

      context 'when price is invalid' do
        it 'is not valid with a nil price' do
          menu_price = build(:menu_price, price: nil, menu: menu, menu_item: menu_item)
          expect(menu_price).not_to be_valid
          expect(menu_price.errors[:price]).to include("can't be blank")
        end

        it 'is not valid with a negative price' do
          menu_price = build(:menu_price, price: -1, menu: menu, menu_item: menu_item)
          expect(menu_price).not_to be_valid
          expect(menu_price.errors[:price]).to include('must be greater than or equal to 0')
        end
      end

      context 'when price is valid' do
        it 'is valid with a price of zero' do
          menu_price = build(:menu_price, price: 0, menu: menu, menu_item: menu_item)
          expect(menu_price).to be_valid
        end

        it 'is valid with a positive price' do
          menu_price = build(:menu_price, price: 10.99, menu: menu, menu_item: menu_item)
          expect(menu_price).to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:menu) }
    it { should belong_to(:menu_item) }
  end
end
