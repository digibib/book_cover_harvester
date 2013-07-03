require "./resource.rb"
require "./review.rb"
require "logger"
require "timeout"

log = Logger.new("result.log")

reviews_to_check = Sparql.fetch_reviews_without_depiction
log.info("Checking #{reviews_to_check.count} reviews")
puts "Found #{reviews_to_check.count} reviews"

reviews_to_check.each do |review|
	r = nil
	begin
		Timeout::timeout(2) {r = Review.new(review)}
	rescue Timeout::Error
		log.info("Timeout on review #{review}")
		next
	end

	print "."

	r.books.each do |book|
		cover_urls = nil
		begin
			Timeout::timeout(2) {cover_urls = Bokkilden.new(book.isbn).check_for_cover_url}
		rescue Timeout::Error
			log.info("Timeout on Bokkilden request for #{book.isbn}")
			next
		end

		cover_urls.each do |cover|
			begin
				Timeout::timeout(2) {book.store_cover_url(cover)}
			rescue Timeout::Error
				log.info("Timeout on storing cover url for #{book.uri}")
				next
			end

			log.info("#{book.uri} - found cover url #{cover}")

		end
	end
end

puts "\ndone"