class Favorite < ApplicationRecord
  berongs_to :user
  berongs_to :book

  validates :user_id, uniqueness: { scope: :book_id }
end
