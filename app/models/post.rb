class Post < ApplicationRecord
  belongs_to :book

  validates :highlight, presence: true
  validates :text,      presence: true
end
