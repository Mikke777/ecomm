class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products
  attribute :checkout_session_id, :string


  validates :customer_email, presence: true
  validates :address, presence: true
  validates :total, presence: true
end
