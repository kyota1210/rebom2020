class OrderAddress
  include ActiveModel::Model
  attr_accessor :token, :user_id, :sale_id, :zip_code, :prefecture_id, :city, :street, :building, :phone_number

  ZIP_CODE_REGEX = /\A\d{3}[-]\d{4}\z/.freeze
  MOBILE_REGEX = /\A\d{11}\z/.freeze
  with_options presence: true do
    validates :token
    validates :user_id
    validates :sale_id
    validates :zip_code,      format: { with: ZIP_CODE_REGEX, message: 'はハイフンを含めて入力してください' }
    validates :prefecture_id, numericality: { other_than: 0, message: 'が選択されていません' }
    validates :city
    validates :street
    validates :phone_number, format: { with: MOBILE_REGEX, message: 'はハイフン無しで入力してください' }
  end

  def save
    order = Order.create(user_id: user_id, sale_id: sale_id)
    Address.create(zip_code: zip_code, prefecture_id: prefecture_id, city: city,
                   street: street, building: building, phone_number: phone_number, order_id: order.id)
  end
end
