module MoveToShowBookSupport
  def move_to_show_book(book)
    expect(page).to have_content('書斎へ行く')
    visit user_path(book.user)
    expect(page).to have_selector('img')
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    visit book_path(book)
  end
end
