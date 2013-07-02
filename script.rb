require "./resource.rb"
require "./review.rb"
require "logger"

log = Logger.new("result.log")

reviews_to_check = Sparql.fetch_reviews_without_depiction
log.info("Checking #{reviews_to_check.count} reviews")
puts "Found #{reviews_to_check.count} reviews"

reviews_to_check[0,10].each do |review|
	r = Review.new(review)
	print "."

	r.books.each do |book|
		cover_urls = Bokkilden.new(book.isbn).check_for_cover_url

		cover_urls.each do |cover|
			log.info("#{book.uri} - found cover url #{cover}")
			book.store_cover_url(book, cover)
		end
	end
end