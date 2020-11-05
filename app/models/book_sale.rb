class BookSale

  include ActiveModel::Model
  attr_accessor :sell, :status, :transfer_fee, :price, :book_id

  PRICE_REGEX = /\A[0-9]+\z/.freeze
  with_options presence: true do
    validates :status,       numericality: { other_than: 0, message: 'が選択されていません' }
    validates :transfer_fee, numericality: { other_than: 0, message: 'が選択されていません' }
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than: 10_000_000, message: 'は¥300~9,999,999で入力してください' },
                      format: { with: PRICE_REGEX, message: 'は半角数字で入力してください' }
  end

  def save
    Sale.create(status_id: status, transfer_fee_id: transfer_fee, price: price, book_id: book_id)
  end
end