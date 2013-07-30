require "rdf"
require "rdf/virtuoso"
require "./settings.rb"
require "./vocabularies.rb"

module Sparql

  REPO = RDF::Virtuoso::Repository.new(Settings::SPARQL_ENDPOINT,
                  :update_uri => Settings::SPARQL_UPDATE_ENDPOINT,
                  :username => Settings::USERNAME,
                  :password => Settings::PASSWORD,
                  :auth_method => 'digest')

  QUERY = RDF::Virtuoso::Query

  def self.fetch_reviews_without_depiction
    q = QUERY.select(:review).distinct.from(Settings::BOOKSGRAPH)
    q.where([:book, RDF::REV.hasReview, :review])
    q.where([:book, RDF.type, RDF::BIBO.Document])
    q.minus([:book, RDF::FOAF.depiction, :cover_url])
    REPO.select(q).bindings[:review]
  end

  def self.fetch_documents_without_depiction(from_year, to_year)
    # Returns manifestations without depiction issued in a given interval.
    # Note that virtuoso  limits the results to 10,000 rows - so don't choose
    # a too large interval.
    q = QUERY.select(:book, :isbn, :bibid).distinct.from(Settings::BOOKSGRAPH)
    q.where([:book, RDF.type, RDF::BIBO.Document])
    q.where([:book, RDF::BIBO.isbn, :isbn])
    q.where([:book, RDF::DEICH.bibliofilID, :bibid])
    q.where([:book, RDF::DC.issued, :issued])
    q.minus([:book, RDF::FOAF.depiction, :cover_url])
    q.filter("xsd:integer(?issued) >= #{from_year} && xsd:integer(?issued) <= #{to_year}")
    REPO.select(q)
  end

  def self.fetch_book_data(review_uri)
    review_uri = RDF::URI(review_uri) unless review_uri.instance_of?(RDF::URI)
    q = QUERY.select(:book, :isbn, :bibid).distinct.from(Settings::BOOKSGRAPH)
    q.where([:book, RDF::REV.hasReview, review_uri])
    q.where([:book, RDF::BIBO.isbn, :isbn])
    q.where([:book, RDF::DEICH.bibliofilID, :bibid])
    q.where([:book, RDF.type, RDF::BIBO.Document])
    REPO.select(q)
  end

  def self.store_cover_url(uri, cover_url)
    q = QUERY.insert_data([uri, RDF::FOAF.depiction, RDF::URI(cover_url)]).graph(Settings::BOOKSGRAPH)
    REPO.insert_data(q)
  end
end
