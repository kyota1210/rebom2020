require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"] 
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'Posts', type: :system do
  before do
    @post = FactoryBot.create(:post)
  end

  it 'Basic認証の通過' do
    basic_pass new_user_session_path
    find('input[name="commit"]').click
  end

  str1 = 'これで10文字です。これで20文字です。これで30文字です。これで40文字です。これで50文字です。これで60文字です。これで70文字です。これで80文字です。これで90文字です。これで100文字です。これで110文字以上です。'
  str2 = str1 + 'これで120文字です。これで130文字です。これで140文字です。これで150文字です。これで160文字です。これで170文字です。これで180文字です。これで190文字です。これで200文字以上です。'

  describe '投稿が成功するとき' do
    it '正しい情報を入力すれば、投稿が成功して本詳細ページに移動する' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページにアウトプットボタンがあることを確認する
      expect(page).to have_content('アウトプット')
      # 投稿詳細ページへ移動する
      visit new_book_post_path(@post.book)
      # 投稿内容を入力する
      fill_in 'post_highlight', with: @post.highlight
      fill_in 'post_text', with: @post.text
      # '保存する'ボタンを押すと、送信した情報がDBに保存されていることを確認する
      expect { click_on('保存する') }.to change { Post.count }.by(1)
      # 本の詳細ページへ遷移していることを確認する
      expect(current_path).to eq book_path(@post.book)
      # 本の詳細ページに投稿のハイライトがあることを確認する
      expect(page).to have_content(@post.highlight)
    end
  end

  describe '投稿が失敗するとき' do
    it 'フォームに不正な値が入力されて、投稿ができなかったとき' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページにアウトプットボタンがあることを確認する
      expect(page).to have_content('アウトプット')
      # 投稿詳細ページへ移動する
      visit new_book_post_path(@post.book)
      # 不正な値を入力する
      fill_in 'post_highlight', with: str1
      fill_in 'post_text', with: str2
      # 保存するボタンを押しても、情報がDBに保存されていないことを確認する
      expect { click_on('保存する') }.to change { Post.count }.by(0)
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts"
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('ハイライトは110字以内で入力してください')
      expect(page).to have_content('本文は200字以内で入力してください')
    end
    it 'フォームが空で送信されて、投稿ができなかったとき' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページにアウトプットボタンがあることを確認する
      expect(page).to have_content('アウトプット')
      # 投稿詳細ページへ移動する
      visit new_book_post_path(@post.book)
      # フォームの値が空であることを確認する
      fill_in 'post_highlight', with: ''
      fill_in 'post_text', with: ''
      # 保存するボタンを押しても、情報がDBに保存されていないことを確認する
      expect { click_on('保存する') }.to change { Post.count }.by(0)
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts"
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('ハイライトを入力してください')
      expect(page).to have_content('本文を入力してください')
    end
  end

  describe '投稿の編集が成功するとき' do
    it '正しい情報を入力すれば、投稿の編集が成功して本詳細ページに移動する' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページに投稿のハイライトがあることを確認する
      expect(page).to have_content(@post.highlight)
      # ハイライトのリンクをクリックする
      click_on(@post.highlight)
      # 投稿の詳細ページに遷移していることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts/#{@post.id}"
      # 投稿の詳細ページに編集ボタンがあることを確認する
      expect(page).to have_content('編集')
      # 投稿の編集ページへ遷移する
      visit "/books/#{@post.book_id}/posts/#{@post.id}/edit"
      # 編集前の投稿内容が表示されていることを確認する
      expect(page).to have_content(@post.highlight)
      expect(page).to have_content(@post.text)
      # 投稿の編集した内容をを入力する
      edit1 = 'ハイライトを編集'
      edit2 = 'テキストを編集'
      fill_in 'post_highlight', with: edit1
      fill_in 'post_text', with: edit2
      # '保存する'ボタンを押す
      click_on('保存する')
      # 本の詳細ページへ遷移していることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts/#{@post.id}"
      # 本の詳細ページに投稿のハイライトがあることを確認する
      expect(page).to have_content(edit1)
    end
  end

  describe '投稿の編集が失敗するとき' do
    it 'フォームに不正な値が入力されて、投稿の編集ができなかったとき' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページに投稿のハイライトがあることを確認する
      expect(page).to have_content(@post.highlight)
      # ハイライトのリンクをクリックする
      click_on(@post.highlight)
      # 投稿の詳細ページに遷移していることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts/#{@post.id}"
      # 投稿の詳細ページに編集ボタンがあることを確認する
      expect(page).to have_content('編集')
      # 投稿の編集ページへ遷移する
      visit "/books/#{@post.book_id}/posts/#{@post.id}/edit"
      # 編集前の投稿内容が表示されていることを確認する
      expect(page).to have_content(@post.highlight)
      expect(page).to have_content(@post.text)
      # 投稿の編集した内容をを入力する
      fill_in 'post_highlight', with: str1
      fill_in 'post_text', with: str2
      # 保存するボタンを押す
      click_on('保存する')
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq "/books/#{@post.book.id}/posts/#{@post.id}"
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('ハイライトは110字以内で入力してください')
      expect(page).to have_content('本文は200字以内で入力してください')
    end
    it 'フォームが空で送信されて、投稿の編集ができなかったとき' do
      # ログインする
      sign_in(@post.book.user)
      # 本の詳細ページへ遷移する
      move_to_show_book(@post.book)
      # 本の詳細ページに投稿のハイライトがあることを確認する
      expect(page).to have_content(@post.highlight)
      # ハイライトのリンクをクリックする
      click_on(@post.highlight)
      # 投稿の詳細ページに遷移していることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts/#{@post.id}"
      # 投稿の詳細ページに編集ボタンがあることを確認する
      expect(page).to have_content('編集')
      # 投稿の編集ページへ遷移する
      visit "/books/#{@post.book_id}/posts/#{@post.id}/edit"
      # 編集前の投稿内容が表示されていることを確認する
      expect(page).to have_content(@post.highlight)
      expect(page).to have_content(@post.text)
      # フォームの値が空であることを確認する
      fill_in 'post_highlight', with: ''
      fill_in 'post_text', with: ''
      # 保存するボタンを押す
      click_on('保存する')
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq "/books/#{@post.book_id}/posts/#{@post.id}"
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('ハイライトを入力してください')
      expect(page).to have_content('本文を入力してください')
    end
  end
end
