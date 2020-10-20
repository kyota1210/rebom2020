class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  
  validates :password, format: { with: PASSWORD_REGEX, message: 'は半角英数字6文字以上で入力してください' }
  validates :name, presence: true
  
  has_many         :books
  has_one_attached :image

end
