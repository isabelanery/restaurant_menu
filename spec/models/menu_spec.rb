require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }

    it 'is not valid with a blank name' do
      menu = build(:menu, name: '')
      expect(menu).not_to be_valid
      expect(menu.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a name containing only spaces' do
      menu = build(:menu, name: '   ')
      expect(menu).not_to be_valid
      expect(menu.errors[:name]).to include("can't be blank")
    end

    it 'is valid with a valid name' do
      menu = build(:menu, name: 'Main Menu')
      expect(menu).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_items).through(:menu_prices) }
  end

  describe 'dependent: :destroy' do
    let(:menu) { create(:menu) }
    let(:menu_item) { create(:menu_item) }
    let!(:menu_prices) { create(:menu_price, menu: menu, menu_item: menu_item) }

    it 'destroys associated menu_items when menu is destroyed' do
      expect { menu.destroy }.to change { MenuPrice.count }.by(-1)
    end
  end
end
