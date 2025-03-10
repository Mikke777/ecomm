class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images do |attachable|
    attachable.variant :medium, resize: "250x250"
  end

  has_many :stocks, dependent: :destroy
  has_many :order_products

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :category_id, presence: true
  validates :images, presence: true
  validate :images_size
  validates :price, numericality: { greater_than: 0 }
  validates :active, inclusion: { in: [true, false] }



  def images_size
    if images.attached?
      images.each do |image|
        if image.blob.byte_size > 200.kilobytes
          errors.add(:images, "size should be less than 200KB")
        end
      end
    end
  end
end
