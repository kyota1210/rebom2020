require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザーは新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'name', with: @user.name
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      # 新規登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect { click_on('登録する')}.to change { User.count }.by(1)
      # 保存されるとトップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 新規登録ページやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザーは新規登録ができずに新規登録がページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'name', with: ''
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      fill_in 'password-confirmation', with: ''
      # 新規登録ボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect {click_on('登録する')}.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq '/users'
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインできるとき' do
    it '保存されているユーザーの情報と合致すればログインできる' do
      # ログインする
      sign_in(@user)
      # 新規登録ページやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      # ユーザー詳細ページへ移動する
      visit user_path(@user)
      # ユーザー詳細ページにログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
    end
  end
  context 'ログインできないとき' do
    it '保存されているユーザーの情報と合致しなければログインできない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンが表示されていることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      # ログインボタンを押す
      click_on('ログイン')
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe 'ユーザー情報編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'ユーザー名とメールアドレスだけでユーザー情報の編集がうまくいくとき' do
    # ログインする
    sign_in(@user)
    # ユーザー詳細ページヘ移動する
    visit user_path(@user)
    # ユーザー詳細ページにユーザー情報編集ページへ遷移できるユーザー名のボタンがあることを確認する
    expect(page).to have_content(@user.name)
    # ユーザー情報編集ページへ移動する
    visit edit_user_path(@user)
    # ユーザー情報を入力する
    fill_in 'name', with: 'example'
    fill_in 'email', with: 'example@example.com'
    # 保存ボタンを押す
    click_on('保存する')
    # ユーザー詳細へ遷移することを確認する
    expect(current_path).to eq user_path(@user)
  end
  it 'ユーザー名、メールアドレス、パスワード、画像、ひとことの全てのユーザー情報の編集がうまくいくとき', js: true do
    # ログインする
    sign_in(@user)
    # ユーザー詳細ページヘ移動する
    visit user_path(@user)
    # ユーザー詳細ページにユーザー情報編集ページへ遷移できるユーザー名のボタンがあることを確認する
    expect(page).to have_content(@user.name)
    # ユーザー情報編集ページへ移動する
    visit edit_user_path(@user)
    # 画像選択フォームに画像を添付する
    attach_file('user_image', Rails.root.join('public/images/user_test_image.png'))
    # ユーザー情報を入力する
    fill_in 'text', with: 'テスト入力'
    fill_in 'name', with: 'example'
    fill_in 'email', with: 'example@example.com'
    # パスワード編集用プルダウンが非表示になっていることを確認する
    expect(find('.accordion-show', visible: false)).to_not be_visible
    # パスワード編集用プルダウンを開く
    find('.change-btn').click
    # 新しいパスワードを入力する
    fill_in 'password', with: 'example1'
    fill_in 'password-confirmation', with: 'example1'
    # 保存ボタンを押す
    click_on('保存する')
    # ユーザー詳細へ遷移することを確認する
    expect(current_path).to eq user_path(@user)
    # 編集したテキストが表示されていることを確認する
    expect(page).to have_content('テスト入力')
    # 編集した画像が表示されていることを確認する
    expect(page).to have_selector('img')
  end
  it 'ユーザー情報の編集がうまくいかないとき' do
    # ログインする
    sign_in(@user)
    # ユーザー詳細ページヘ移動する
    visit user_path(@user)
    # ユーザー詳細ページにユーザー情報編集ページへ遷移できるユーザー名のボタンがあることを確認する
    expect(page).to have_content(@user.name)
    # ユーザー情報編集ページへ移動する
    visit edit_user_path(@user)
    fill_in 'name', with: ''
    fill_in 'email', with: ''
    # 保存ボタンを押す
    click_on('保存する')
    # エラーメッセージが表示されていることを確認する
    expect(page).to have_content('ユーザー名を入力してください')
    expect(page).to have_content('Eメールを入力してください')
  end
end
