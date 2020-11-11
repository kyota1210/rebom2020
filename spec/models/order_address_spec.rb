require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  before do
    @order_address = FactoryBot.build(:order_address)
  end

  it 'すべての値が正しく入力されていれば保存できること' do
    expect(@order_address).to be_valid
  end
  it 'tokenが空では保存できないこと' do
    @order_address.token = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('クレジットカード情報を入力してください')
  end
  it '郵便番号が空では保存できないこと' do
    @order_address.zip_code = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('郵便番号を入力してください')
  end
  it '郵便番号にハイフンが無ければ保存できないこと' do
    @order_address.zip_code = 1_234_567
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('郵便番号はハイフンを含めて入力してください')
  end
  it '都道府県の情報が空では保存できないこと' do
    @order_address.prefecture_id = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('都道府県が選択されていません')
  end
  it '都道府県の情報で0が選択されていると保存できないこと' do
    @order_address.prefecture_id = 0
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('都道府県が選択されていません')
  end
  it '市区町村が空では保存できないこと' do
    @order_address.city = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('市区町村を入力してください')
  end
  it '番地が空では保存できないこと' do
    @order_address.street = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('番地を入力してください')
  end
  it '建物名は空でも保存できること' do
    @order_address.building = ''
    expect(@order_address).to be_valid
  end
  it '電話番号が空では保存できないこと' do
    @order_address.phone_number = ''
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('電話番号を入力してください')
  end
  it '電話番号にハイフンがあると保存できないこと' do
    @order_address.phone_number = '090-1234-5678'
    @order_address.valid?
    expect(@order_address.errors.full_messages).to include('電話番号はハイフン無しで入力してください')
  end
end
