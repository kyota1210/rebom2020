require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "OrderAddresses", type: :system do
  before do
    @book = FactoryBot.create(:book)
    @sale = FactoryBot.create(:sale)
    @user = FactoryBot.create(:user)
    @order_address = FactoryBot.build(:order_address)
  end

  it 'Basic認証の通過' do
    basic_pass new_user_session_path
    find('input[name="commit"]').click
  end


  context '正しい情報を入力して、本の購入ができるとき' do
    it '本の購入に成功する' do
      # 他のユーザーによって本が出品されている状態であることが前提
      sign_in(@book.user)
      sale_book(@book, @sale)
      click_on('ログアウト')
      # ログインする
      sign_in(@user)
      # トップページに出品された本があることを確認する
      expect(page).to have_content('出品中')
      # 出品中ボタンを押して、本の出品情報詳細ページへ遷移する
      click_on('出品中')
      visit sale_path(@book)
      # 購入画面へ行くボタンを押して、本購入ページへ遷移する
      click_on('購入画面へ行く')
      visit sale_orders_path(@sale)
      # クレジットカード情報を入力する
      fill_in 'card-number', with: 4242424242424242
      fill_in 'card-exp-month', with: 3
      fill_in 'card-exp-year', with: 30
      fill_in 'card-cvc', with: 123
      # 購入者情報を入力する
      fill_in 'postal-code', with: @order_address.zip_code
      find('.select-box').click
      select '北海道', from: 'prefecture'
      fill_in 'city', with: @order_address.city
      fill_in 'addresses', with: @order_address.street
      fill_in 'building', with: @order_address.building
      fill_in 'phone-number', with: @order_address.phone_number
      # 購入ボタンを押す
      click_on('購入')
      # 購入した本について出品中という表示が消えていることを確認する
      expect(page).to have_no_content('出品中')
    end
  end
  context '入力情報が誤っていて、本の購入ができないとき' do
    it '購入者情報が空で送信されて、購入できないこと' do
      # 他のユーザーによって本が出品されている状態であることが前提
      sign_in(@book.user)
      sale_book(@book, @sale)
      click_on('ログアウト')
      # ログインする
      sign_in(@user)
      # トップページに出品された本があることを確認する
      expect(page).to have_content('出品中')
      # 出品中ボタンを押して、本の出品情報詳細ページへ遷移する
      click_on('出品中')
      visit sale_path(@book)
      # 購入画面へ行くボタンを押して、本購入ページへ遷移する
      click_on('購入画面へ行く')
      visit sale_orders_path(@sale)
      # クレジットカード情報を入力する
      fill_in 'card-number', with: ''
      fill_in 'card-exp-month', with: ''
      fill_in 'card-exp-year', with: ''
      fill_in 'card-cvc', with: ''
      # 購入者情報を入力する
      fill_in 'postal-code', with: ''
      fill_in 'city', with: ''
      fill_in 'addresses', with: ''
      fill_in 'building', with: ''
      fill_in 'phone-number', with: ''
      # 購入ボタンを押す
      click_on('購入')
      # 購入は失敗して、エラーメッセージが表示されていることを確認する
      expect(page).to have_content('クレジットカード情報を入力してください')
      expect(page).to have_content('郵便番号を入力してください')
      expect(page).to have_content('郵便番号はハイフンを含めて入力してください')
      expect(page).to have_content('都道府県が選択されていません')
      expect(page).to have_content('市区町村を入力してください')
      expect(page).to have_content('番地を入力してください')
      expect(page).to have_content('電話番号を入力してください')
      expect(page).to have_content('電話番号はハイフン無しで入力してください')
    end

    it 'クレジットカード情報に誤りがあり、購入できないこと' do
      # 他のユーザーによって本が出品されている状態であることが前提
      sign_in(@book.user)
      sale_book(@book, @sale)
      click_on('ログアウト')
      # ログインする
      sign_in(@user)
      # トップページに出品された本があることを確認する
      expect(page).to have_content('出品中')
      # 出品中ボタンを押して、本の出品情報詳細ページへ遷移する
      click_on('出品中')
      visit sale_path(@book)
      # 購入画面へ行くボタンを押して、本購入ページへ遷移する
      click_on('購入画面へ行く')
      visit sale_orders_path(@sale)
      # クレジットカード情報を入力する
      fill_in 'card-number', with: 4242424242424241
      fill_in 'card-exp-month', with: 3
      fill_in 'card-exp-year', with: 3
      fill_in 'card-cvc', with: 456
      # 購入者情報を入力する
      fill_in 'postal-code', with: @order_address.zip_code
      find('.select-box').click
      select '北海道', from: 'prefecture'
      fill_in 'city', with: @order_address.city
      fill_in 'addresses', with: @order_address.street
      fill_in 'building', with: @order_address.building
      fill_in 'phone-number', with: @order_address.phone_number
      # 購入ボタンを押す
      click_on('購入')
      # 購入は失敗して、エラーメッセージが表示されていることを確認する
      expect(page).to have_content('クレジットカード情報を入力してください')
    end
    it '購入者情報に誤りがあり、購入できないこと' do
      # 他のユーザーによって本が出品されている状態であることが前提
      sign_in(@book.user)
      sale_book(@book, @sale)
      click_on('ログアウト')
      # ログインする
      sign_in(@user)
      # トップページに出品された本があることを確認する
      expect(page).to have_content('出品中')
      # 出品中ボタンを押して、本の出品情報詳細ページへ遷移する
      click_on('出品中')
      visit sale_path(@book)
      # 購入画面へ行くボタンを押して、本購入ページへ遷移する
      click_on('購入画面へ行く')
      visit sale_orders_path(@sale)
      # クレジットカード情報を入力する
      fill_in 'card-number', with: 4242424242424242
      fill_in 'card-exp-month', with: 3
      fill_in 'card-exp-year', with: 30
      fill_in 'card-cvc', with: 123
      # 購入者情報を入力する
      fill_in 'postal-code', with: 1234567
      fill_in 'city', with: @order_address.city
      fill_in 'addresses', with: @order_address.street
      fill_in 'building', with: @order_address.building
      fill_in 'phone-number', with: '090-1234-5678'
      # 購入ボタンを押す
      click_on('購入')
      # 購入は失敗して、エラーメッセージが表示されていることを確認する
      expect(page).to have_content('郵便番号はハイフンを含めて入力してください')
      expect(page).to have_content('都道府県が選択されていません')
      expect(page).to have_content('電話番号はハイフン無しで入力してください')
    end
  end
end
