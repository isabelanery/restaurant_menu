class MenuItem < ApplicationRecord
  belongs_to :menu
  validates :name, presence: true, allow_blank: false
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
