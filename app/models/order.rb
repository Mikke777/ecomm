class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products
  attribute :checkout_session_id, :string
end
