class Sale < ApplicationRecord
  belongs_to :book

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status
  belongs_to_active_hash :transfer_fee

  PRICE_REGEX = /\A[0-9]+\z/.freeze
  with_options presence: true do
    validates :status_id,       numericality: { other_than: 0, message: 'が選択されていません' }
    validates :transfer_fee_id, numericality: { other_than: 0, message: 'が選択されていません' }
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than: 10_000_000, message: 'は¥300~9,999,999で入力してください' },
                      format: { with: PRICE_REGEX, message: 'は半角数字で入力してください' }
  end
end
