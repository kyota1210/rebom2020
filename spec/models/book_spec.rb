require 'rails_helper'

RSpec.describe Book, type: :model do
  before do
    @book = FactoryBot.build(:book)
  end

  describe '本の追加' do
    context '本の追加が上手くいくとき' do
      it 'title、author、imageが存在すれば追加できる' do
        expect(@book).to be_valid
      end
    end
    context '本の追加が上手くいかないとき' do
      it 'titleが空だと追加できないこと' do
        @book.title = ""
        @book.valid?
        expect(@book.errors.full_messages).to include("Title can't be blank")
      end
      it 'authorが空だと追加できないこと' do
        @book.author = ""
        @book.valid?
        expect(@book.errors.full_messages).to include("Author can't be blank")
      end
      it 'imageが空だと追加できないこと' do
        @book.image = nil
        @book.valid?
        expect(@book.errors.full_messages).to include("Image can't be blank")
      end
      it '追加した本がユーザーと結びついていること' do
        @book.user = nil
        @book.valid?
        expect(@book.errors.full_messages).to include("User must exist")
      end
    end
  end
end
