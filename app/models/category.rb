class Category < ApplicationRecord
  has_one_attached :image
  has_many :products

  validates :name, presence: true
  validates :description, presence: true
  validates :image, presence: true
  validate :image_size


  def image_size
    if image.attached? && image.blob.byte_size > 200.kilobytes
      errors.add(:photo, "size should be less than 200KB")
    end
  end
end
