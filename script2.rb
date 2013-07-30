require "./resource.rb"
require "./review.rb"
require "logger"
require "timeout"

log = Logger.new("result.log")

documents_to_check = Sparql.fetch_documents_without_depiction(2012, 2013)
resources = [Katalogkrydder, Bokkilden]
log.info("Checking #{documents_to_check.count} documents")
puts "Found #{documents_to_check.count} documents"

documents_to_check.each do |doc|
  cover_urls = []
  book = Book.new(doc.book, doc.isbn, doc.bibid)
  print "."
  begin
    Timeout::timeout(5) {
      resources.each { |r| cover_urls += r.new(book.isbn, book.bibid).check_for_cover_url }
    }
  rescue Timeout::Error
    log.info("Timeout on request for #{book.isbn}")
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

puts "\ndone"