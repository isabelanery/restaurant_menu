class Menu < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_prices, dependent: :destroy
  has_many :menu_items, through: :menu_prices

  validates :name, presence: true, allow_blank: false
end
