require 'rails_helper'

RSpec.describe BookSale, type: :model do
  before do
    @book_sale = FactoryBot.build(:book_sale)
  end

  describe '本の出品' do
    context '本の出品が上手くいくとき' do
      it '本の状態、配送料の負担、価格が正しく入力されていれば追加できる' do
        expect(@book_sale).to be_valid
      end
    end

    context '本の出品が上手くいかないとき' do
      it '本の状態が存在しないと出品できないこと' do
        @book_sale.status = 0
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('本の状態が選択されていません')
      end
      it '配送料の負担が存在しないと出品できないこと' do
        @book_sale.transfer_fee = 0
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('配送料の負担が選択されていません')
      end
      it '価格が存在しないと出品できないこと' do
        @book_sale.price = ''
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('価格を入力してください')
      end
      it '価格が299円以下の場合、出品できないこと' do
        @book_sale.price = 299
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
      it '価格が10,000,000円以上の場合、出品できないこと' do
        @book_sale.price = 10_000_000
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
      it '価格が半角数字で入力されてなければ出品できないこと' do
        @book_sale.price = '５００'
        @book_sale.valid?
        expect(@book_sale.errors.full_messages).to include('価格は¥300~9,999,999で入力してください')
      end
    end
  end
end
