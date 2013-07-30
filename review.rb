require "./sparql.rb"

class Review
  attr_reader :books

  def initialize(uri)
    @uri = uri
    @books = Array(find_books(@uri))
  end

  private

  def find_books(uri)
    books = Sparql.fetch_book_data(uri)
    books.map { |book|
      Book.new(book.book, book.isbn, book.bibid)
    }
  end
end

class Book
  attr_reader :isbn, :uri, :bibid

  def initialize(uri, isbn, bibid)
    @uri = uri
    @isbn = isbn
    @bibid = bibid
  end

  def store_cover_url(cover_url)
    Sparql.store_cover_url(@uri, cover_url)
  end
end