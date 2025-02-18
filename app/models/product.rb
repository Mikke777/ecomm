class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :stocks, dependent: :destroy
end
