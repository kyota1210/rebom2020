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
        it 'highlightが110字以内であれば投稿できる' do
          @post.highlight = '110文字以内のハイライト'
          expect(@post).to be_valid
        end
        it 'textが200字以内であれば投稿できる' do
          @post.text = '200文字以内の文章'
          expect(@post).to be_valid
        end
      end

      context '投稿が上手くいかないとき' do
        it 'highlightが空だと投稿できないこと' do
          @post.highlight = ""
          @post.valid?
          expect(@post.errors.full_messages).to include("ハイライトを入力してください")
        end
        it 'highlightが110字以上だと投稿できないこと' do
          @post.highlight = 'これで10文字です。これで20文字です。これで30文字です。これで40文字です。これで50文字です。これで60文字です。これで70文字です。これで80文字です。これで90文字です。これで100文字です。これで110文字を超えています。'
          @post.valid?
          expect(@post.errors.full_messages).to include("ハイライトは110字以内で入力してください")
        end
        it 'textが空だと投稿できないこと' do
          @post.text = ""
          @post.valid?
          expect(@post.errors.full_messages).to include("本文を入力してください")
        end
        it 'textが200字以上だと投稿できないこと' do
          @post.text = 'これで10文字です。これで10文字です。これで20文字です。これで30文字です。これで40文字です。これで50文字です。これで60文字です。これで70文字です。これで80文字です。これで90文字です。これで100文字です。これで110文字です。これで120文字です。これで130文字です。これで140文字です。これで150文字です。これで160文字です。これで170文字です。これで180文字です。これで190文字です。これで200文字を超えています。'
          @post.valid?
          expect(@post.errors.full_messages).to include("本文は200字以内で入力してください")
        end
        it '投稿がbookと紐付いていること' do
          @post.book = nil
          @post.valid?
          expect(@post.errors.full_messages).to include("Bookを入力してください")
        end
      end
    end
end
