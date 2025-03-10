class Stock < ApplicationRecord
  belongs_to :product

  validates :amount, presence: true
  validates :size, presence: true
end
