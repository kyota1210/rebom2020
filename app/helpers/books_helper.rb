module BooksHelper
  def book_list(books)
    html = ''
    books.each do |book|
      html += render(partial: 'books', locals: { book: book })
    end
  render raw(html)
  end
end
