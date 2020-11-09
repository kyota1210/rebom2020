class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates :password, presence: true, on: :create, format: { with: PASSWORD_REGEX, message: 'は半角英数字6文字以上で入力してください' }
  validates :password_confirmation, presence: true, on: :create
  validates :name, presence: true, length: { maximum: 10, message: 'は10字以内で入力してください' }
  validates :email, presence: true

  has_many         :books, dependent: :destroy
  has_many         :favorites, dependent: :destroy
  has_many         :favorite_books, through: :favorites, source: :book
  has_one_attached :image
  has_many         :orders

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    clean_up_passwords
    update_attributes(params, *options)
  end

  def favorite(book)
    favorite_books << book
  end

  def unfavorite(book)
    favorite_books.destroy(book)
  end

  def favorite?(book)
    favorite_books.include?(book)
  end
end
