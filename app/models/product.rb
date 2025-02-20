class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images do |attachable|
    attachable.variant :medium, resize: "250x250"
  end

  has_many :stocks, dependent: :destroy
  has_many :order_products
end
