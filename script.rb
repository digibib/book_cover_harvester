require "faraday"
require "./sparql.rb"
require "nokogiri"


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
end

class Resource

	def initialize(isbn)
		@isbn = isbn
		prepare_request
	end

	def prepare_request
		nil
	end

	def check_for_cover_url
		result = Faraday.get(@path+@query_params)
		parse_result(result)
	end

	def parse_result(result)
		raise NotImplementedError
	end

end

class Bokkilden < Resource

	def prepare_request
		@path = "http://partner.bokkilden.no/SamboWeb/partner.do"
		@query_params = "?rom=MP&format=XML&uttrekk=5&pid=0&ept=3&xslId=117&antall=10&enkeltsok=#{@isbn}&profil=partner&sort=popularitet&order=DESC"
	end

	def parse_result(result)



end