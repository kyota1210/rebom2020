class Book < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_one_attached :image
  has_many :book_tag_relations, dependent: :destroy
  has_many :tags, through: :book_tag_relations

  with_options presence: :true do
    validates :title,  length: { maximum: 36, message: 'は36字以内で入力してください' }
    validates :author, length: { maximum: 23, message: 'は23字以内で入力してください' }
    validates :image
  end
  
  def save_books(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
  
    # Destroy
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    # Create
    new_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name:new_name)
      self.tags << book_tag
    end
  end
end
