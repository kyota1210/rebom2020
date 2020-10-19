class Book < ApplicationRecord
  belongs_to :user
  has_many :posts
  has_one_attached :image

  validates :title,  presence: true
  validates :author, presence: true
  validates :image, presence: true
end
