class Address < ApplicationRecord
  belongs_to :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  ZIP_CODE_REGEX = /\A\d{3}[-]\d{4}\z/.freeze
  MOBILE_REGEX = /\A\d{11}\z/.freeze
  with_options presence: true do
    validates :zip_code,      format: { with: ZIP_CODE_REGEX, message: 'はハイフンを含めて入力してください' }
    validates :prefecture_id, numericality: { other_than: 0, message: 'が選択されていません' }
    validates :city
    validates :street
    validates :phone_number, format: { with: MOBILE_REGEX, message: 'が正しく入力されていません' }
end
