class MenuPrice < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
