require "./sparql.rb"


class Review
	def initialize(uri)
		@uri = uri
		@books = Array(find_books(@uri))
	end

	private

	def find_books(uri)
		books = Sparql.fetch_book_data(uri)
		books.map { |book|
			Book.new(book.book, book.isbn)
		}
	end
end

class Book

	def initialize(uri, isbn)
		@uri = uri
		@isbn = isbn
	end

	def store_cover_url(cover_url)
		Sparql.store_cover_url(@uri, cover_url)
	end

end