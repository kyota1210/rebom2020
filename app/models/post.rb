class Post < ApplicationRecord
  belongs_to :book

  with_options presence: true do
    validates :highlight,   length: { maximum: 110, message: "は110字以内で入力してください" }
    validates :text,        length: { maximum: 200, message: "は200字以内で入力してください" }
  end
end
