require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'Sales', type: :system do
  before do
    @sale = FactoryBot.create(:sale)
    @book = FactoryBot.create(:book)
  end

  it 'Basic認証の通過' do
    basic_pass new_user_session_path
    find('input[name="commit"]').click
  end

  describe '本を出品する' do
    context '本の出品がうまくいくとき' do
      it '正しい情報を入力すれば、本の出品が成功してユーザー詳細ページに移動する' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
      end
    end
    context '本の出品がうまくいかないとき' do
      it '価格が不正な値で入力されて本の出品ができないとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # ユーザー詳細ページの追加した本に出品ボタン表示されていることを確認する
        expect(page).to have_content('売る')
        # 出品ボタンを押す
        click_on('売る')
        # 本出品ページへ遷移する
        visit new_sale_path(id: @book.id)
        # 本の状態を選択する
        find('.select-box1').click
        select '新品', from: 'item-sales-status'
        # 配送料負担について選択する
        find('.select-box2').click
        select '着払い(購入者負担)', from: 'item-shipping-fee-status'
        # 本の価格を入力する
        fill_in 'sale[price]', with: '200'
        # 「出品する」ボタンを押しても、送信した情報がDBに保存されていないことを確認する
        expect { click_on('出品する') }.to change { Sale.count }.by(0)
        # エラーメッセージが出ていることを確認する
        expect(page).to have_content('価格は¥300~9,999,999で入力してください')
      end
      it 'フォームが空で送信されて本の出品ができないとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # ユーザー詳細ページの追加した本に出品ボタン表示されていることを確認する
        expect(page).to have_content('売る')
        # 出品ボタンを押す
        click_on('売る')
        # 本出品ページへ遷移する
        visit new_sale_path(id: @book.id)
        # 本の価格を入力する
        fill_in 'sale[price]', with: ''
        # 「出品する」ボタンを押しても、送信した情報がDBに保存されていないことを確認する
        expect { click_on('出品する') }.to change { Sale.count }.by(0)
        # エラーメッセージが出ていることを確認する
        expect(page).to have_content('本の状態が選択されていません')
        expect(page).to have_content('配送料の負担が選択されていません')
        expect(page).to have_content('価格を入力してください')
        expect(page).to have_content('価格は¥300~9,999,999で入力してください')
        expect(page).to have_content('価格は半角数字で入力してください')
      end
    end
  end
  describe '出品した本情報を編集する' do
    context '出品した本情報の編集がうまくいくとき' do
      it '正しい情報を入力すれば、出品した本情報の編集が成功してトップページに移動する' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
        # 出品中ボタンを押す
        click_on('出品中')
        # 本の出品情報編集ページに遷移する
        visit edit_sale_path(@book)
        # 本の状態を選択する
        find('.select-box1').click
        select '新品', from: 'item-sales-status'
        # 配送料負担について選択する
        find('.select-box2').click
        select '着払い(購入者負担)', from: 'item-shipping-fee-status'
        # 本の価格を入力する
        fill_in 'sale[price]', with: @sale.price
        # 「更新する」ボタンを押す
        click_on('更新する')
        # ユーザー詳細ページに遷移していることを確認する
        expect(current_path).to eq user_path(@book.user)
      end
    end
    context '出品した本情報の編集がうまくいかないとき' do
      it '価格が不正な値で入力されて本の出品情報の編集ができないとき' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
        # 出品中ボタンを押す
        click_on('出品中')
        # 本の出品情報編集ページに遷移する
        visit edit_sale_path(@book)
        # 本の状態を選択する
        find('.select-box1').click
        select '新品', from: 'item-sales-status'
        # 配送料負担について選択する
        find('.select-box2').click
        select '着払い(購入者負担)', from: 'item-shipping-fee-status'
        # 本の価格を入力する
        fill_in 'sale[price]', with: '100'
        # 「更新する」ボタンを押しても、送信した情報がDBに保存されていないことを確認する
        expect { click_on('更新する') }.to change { Sale.count }.by(0)
      end
      it 'フォームが空で送信されて本の出品情報の編集ができないとき' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
        # 出品中ボタンを押す
        click_on('出品中')
        # 本の出品情報編集ページに遷移する
        visit edit_sale_path(@book)
        # 本の状態を選択する
        find('.select-box1').click
        select '---', from: 'item-sales-status'
        # 配送料負担について選択する
        find('.select-box2').click
        select '---', from: 'item-shipping-fee-status'
        # 本の価格を入力する
        fill_in 'sale[price]', with: ''
        # 「更新する」ボタンを押しても、送信した情報がDBに保存されていないことを確認する
        expect { click_on('更新する') }.to change { Sale.count }.by(0)
      end
    end
    context '本の出品を取り消すとき' do
      it 'トップページから出品情報を確認し、出品を取り消すボタンを押すと出品を取り消すことができ、トップページに遷移する' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
        # トップページへ遷移する
        visit root_path
        # 出品中ボタンを押す
        click_on('出品中')
        # 出品を取り消すボタンがあることを確認する
        expect(page).to have_content('出品を取り消す')
        # 出品を取り消すボタンを押すと、情報がDBから削除されることを確認する
        expect { click_on('出品を取り消す') }.to change { Sale.count }.by(-1)
        # トップページに戻ってくることを確認する
        expect(current_path).to eq root_path
        # 出品中マークが表示されていないことを確認する
        expect(page).to have_no_content('出品中')
      end
      it '出品情報編集ページで出品を取り消すボタンを押すと出品を取り消すことができ、トップページに遷移する' do
        # ログインする
        sign_in(@book.user)
        # 本を出品する
        sale_book(@book, @sale)
        # 出品中ボタンを押す
        click_on('出品中')
        # 本の出品情報編集ページに遷移する
        visit edit_sale_path(@book)
        # 出品を取り消すボタンがあることを確認する
        expect(page).to have_content('出品を取り消す')
        # 出品を取り消すボタンを押すと、情報がDBから削除されることを確認する
        expect { click_on('出品を取り消す') }.to change { Sale.count }.by(-1)
        # トップページに戻ってくることを確認する
        expect(current_path).to eq root_path
        # 出品中マークが表示されていないことを確認する
        expect(page).to have_no_content('出品中')
      end
    end
  end
end
