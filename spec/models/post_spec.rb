require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end
    describe '記事の投稿' do
      context '投稿が上手くいくとき' do
        it 'highlight、textが存在すれば投稿できる' do
          expect(@post).to be_valid
        end
      end

      context '投稿が上手くいかないとき' do
        it 'highlightが空だと投稿できないこと' do
          @post.highlight = ""
          @post.valid?
          expect(@post.errors.full_messages).to include("ハイライトを入力してください")
        end
        it 'textが空だと投稿できないこと' do
          @post.text = ""
          @post.valid?
          expect(@post.errors.full_messages).to include("本文を入力してください")
        end
        it '投稿がbookと紐付いていること' do
          @post.book = nil
          @post.valid?
          expect(@post.errors.full_messages).to include("Bookを入力してください")
        end
      end
    end
end
