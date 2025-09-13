class MenuItem < ApplicationRecord
  has_many :menu_prices, dependent: :destroy
  has_many :menus, through: :menu_prices

  validates :name, presence: true,
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }
end
