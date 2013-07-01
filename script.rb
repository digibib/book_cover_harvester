require "faraday"
require "./sparql.rb"


class Review
	def initialize(uri)
		@uri = uri
		find_book
	end

	private

	def find_book
		# TODO SPARQL query
	end
end

class Book
	def intialize(uri)
		@uri = uri
	end
end

class Resource
	def intialize(uri)
		@uri = uri
	end
end

class Bokkilden < Resource
end