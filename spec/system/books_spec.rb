require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"] 
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'Books', type: :system do
  before do
    @book = FactoryBot.create(:book)
  end

  it 'Basic認証の通過' do
    basic_pass new_user_session_path
    find('input[name="commit"]').click
  end

  str1 = 'これで10文字です。これで20文字です。これで30文字です。これで40文字です。これで50文字です。'
  str2 = 'これで10文字です。これで20文字です。これで30文字です。'

  describe '本の追加' do
    context '本の追加ができたとき' do
      it '本を追加するとトップページに遷移し、トップページとユーザー詳細ページに、追加した情報が表示されている' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 本の情報を入力する
        fill_in 'title', with: @book.title
        fill_in 'author', with: @book.author
        # '追加する'ボタンを押すと送信した情報がDBに保存されていることを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(1)
        # トップページに遷移していることを確認する
        expect(current_path).to eq root_path
        # 追加した本の情報がトップページに表示されていることを確認する
        expect(page).to have_selector('img')
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # 追加した本の情報がユーザー詳細ページに表示されていることを確認する
        expect(page).to have_selector('img')
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
      end
    end
    context '本の追加ができなかったとき' do
      it 'フォームに不正な値が入力されて、本の追加ができなかったとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 不正な値を入力する
        fill_in 'title', with: str1
        fill_in 'author', with: str2
        # 追加するボタンをクリックしても、情報がDBに保存されていないことを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(0)
        # 元のページに戻ってくることを確認する
        expect(current_path).to eq '/books'
        # エラーメッセージが表示されていることを確認する
        expect(page).to have_content('タイトルは36字以内で入力してください')
        expect(page).to have_content('著者名は23字以内で入力してください')
      end
      it 'フォームが空で送信されて、本の追加ができなかったとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # フォームの値が空であることを確認する
        fill_in 'title', with: ''
        fill_in 'author', with: ''
        # 追加するボタンをクリックしても、情報がDBに保存されていないことを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(0)
        # 元のページに戻ってくることを確認する
        expect(current_path).to eq '/books'
        # エラーメッセージが表示されていることを確認する
        expect(page).to have_content('タイトルを入力してください')
        expect(page).to have_content('著者名を入力してください')
        expect(page).to have_content('画像を入力してください')
      end
    end
  end

  describe '追加した本情報の編集' do
    context '追加した本情報の編集がうまくいくとき' do
      it '本情報の編集がうまくいくと、トップページに遷移し、トップページとユーザー詳細ページに、追加した情報が表示されている' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 本の情報を入力する
        fill_in 'title', with: @book.title
        fill_in 'author', with: @book.author
        # '追加する'ボタンを押すと送信した情報がDBに保存されていることを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(1)
        # トップページに遷移していることを確認する
        expect(current_path).to eq root_path
        # 追加した本の情報がトップページに表示されていることを確認する
        expect(page).to have_selector('img')
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # ユーザー詳細ページの追加した本に編集ボタン表示されていることを確認する
        expect(page).to have_content('編集')
        # 編集ボタンを押す
        find_link('編集', href: edit_book_path(@book)).click
        # 本情報編集ページに遷移する
        visit edit_book_path(@book)
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 本の情報を編集した内容を入力する
        book_title = "新タイトル"
        book_author = "新著者"
        fill_in 'title', with: book_title
        fill_in 'author', with: book_author
        # '追加する'ボタンを押す
        click_on('追加する')
        # ユーザー詳細ページに遷移していることを確認する
        expect(current_path).to eq user_path(@book.user)
      end
    end
    context '追加した本情報の編集がうまくいかないとき' do
      it 'フォームに不正な値が入力されて、本の追加ができなかったとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 本の情報を入力する
        fill_in 'title', with: @book.title
        fill_in 'author', with: @book.author
        # '追加する'ボタンを押すと送信した情報がDBに保存されていることを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(1)
        # トップページに遷移していることを確認する
        expect(current_path).to eq root_path
        # 追加した本の情報がトップページに表示されていることを確認する
        expect(page).to have_selector('img')
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # ユーザー詳細ページの追加した本に編集ボタン表示されていることを確認する
        expect(page).to have_content('編集')
        # 編集ボタンを押す
        find_link('編集', href: edit_book_path(@book)).click
        # 本情報編集ページに遷移する
        visit edit_book_path(@book)
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 不正な値を入力する
        fill_in 'title', with: str1
        fill_in 'author', with: str2
        # '追加する'ボタンを押す
        click_on('追加する')
        # 元のページに戻ってくることを確認する
        expect(current_path).to eq "/books/#{@book.id}"
        # エラーメッセージが表示されていることを確認する
        expect(page).to have_content('タイトルは36字以内で入力してください')
        expect(page).to have_content('著者名は23字以内で入力してください')
      end
      it 'フォームが空で送信されて、本情報の編集がうまくいかないとき' do
        # ログインする
        sign_in(@book.user)
        # トップページに本の追加ボタンがあることを確認する
        expect(page).to have_content('追加する')
        # 本の追加ボタンを押す
        find('.add-btn').click
        # 本の追加ページに遷移する
        visit new_book_path
        # 画像選択フォームに画像を添付する
        attach_file('book_image', Rails.root.join('public/images/test_image.png'))
        # 本の情報を入力する
        fill_in 'title', with: @book.title
        fill_in 'author', with: @book.author
        # '追加する'ボタンを押すと送信した情報がDBに保存されていることを確認する
        expect { click_on('追加する') }.to change { Book.count }.by(1)
        # トップページに遷移していることを確認する
        expect(current_path).to eq root_path
        # 追加した本の情報がトップページに表示されていることを確認する
        expect(page).to have_selector('img')
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.author)
        # トップページに'書斎へ行く'ボタンがあることを確認する
        expect(page).to have_content('書斎へ行く')
        # ユーザー詳細ページへ遷移する
        visit user_path(@book.user)
        # ユーザー詳細ページの追加した本に編集ボタン表示されていることを確認する
        expect(page).to have_content('編集')
        # 編集ボタンを押す
        find_link('編集', href: edit_book_path(@book)).click
        # 本情報編集ページに遷移する
        visit edit_book_path(@book)
        # 不正な値を入力する
        fill_in 'title', with: ''
        fill_in 'author', with: ''
        # '追加する'ボタンを押す
        click_on('追加する')
        # 元のページに戻ってくることを確認する
        expect(current_path).to eq "/books/#{@book.id}"
        # エラーメッセージが表示されていることを確認する
        expect(page).to have_content('タイトルを入力してください')
        expect(page).to have_content('著者名を入力してください')
      end
    end
  end
end
