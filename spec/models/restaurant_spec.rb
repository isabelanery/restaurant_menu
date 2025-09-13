require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should have_many(:menus).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'multiple menus' do
    let(:restaurant) { create(:restaurant) }
    let(:menu1) { create(:menu, restaurant: restaurant) }
    let(:menu2) { create(:menu, restaurant: restaurant) }

    it 'can have multiple menus' do
      expect(restaurant.menus).to include(menu1, menu2)
    end
  end
end
