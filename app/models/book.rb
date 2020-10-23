class Book < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one_attached :image

  with_options presence: true do
    validates :title,  length: { maximum: 36, message: 'は36字以内で入力してください' }
    validates :author, length: { maximum: 23, message: 'は23字以内で入力してください' }
    validates :image
  end
end
