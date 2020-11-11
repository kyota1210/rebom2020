require 'rails_helper'

RSpec.describe Sale, type: :model do
  before do
    @sale = FactoryBot.build(:sale)
  end

  describe '本の出品' do
    context '本の出品がうまくいくとき' do
      it '本の状態、配送料負担、価格が存在すれば出品できる' do
        expect(@sale).to be_valid
      end
    end
    context '本の出品がうまくいかないとき' do
      it '本の状態にが選択されていなければ出品できないこと' do
        @sale.status_id = ''
        @sale.valid?
        expect(@sale.errors.full_messages).to include('本の状態が選択されていません')
      end
      it '配送料負担について入力されていなければ出品できないこと' do
        @sale.transfer_fee_id = ''
        @sale.valid?
        expect(@sale.errors.full_messages).to include('配送料の負担が選択されていません')
      end
      it '価格が入力されていなければ出品できないこと' do
        @sale.price = ''
        @sale.valid?
        expect(@sale.errors.full_messages).to include('価格を入力してください')
      end
      it '価格が300円以上で入力されていなければ出品できないこと' do
        @sale.price = 299
        @sale.valid?
        expect(@sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
      it '価格が9,999,999円以下で入力されていなければ出品できないこと' do
        @sale.price = 10_000_000
        @sale.valid?
        expect(@sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
      it '価格が半角数字で入力されていなければ出品できないこと' do
        @sale.price = '５００'
        @sale.valid?
        expect(@sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
      it '出品情報が本と紐付いていること' do
        @sale.book = nil
        @sale.valid?
        expect(@sale.errors.full_messages).to include('Bookを入力してください')
      end
    end
  end
end
