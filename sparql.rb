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
		q.where([:book, RDF::REV.hasReview, :review],)
		q.where([:book, RDF.type, RDF::BIBO.Document])
		q.minus([:book, RDF::FOAF.depiction, :cover_url])
		REPO.select(q).bindings[:review]
	end

	def self.fetch_book_data(review_uri)
		review_uri = RDF::URI(review_uri) unless review_uri.instance_of?(RDF::URI)
		q = QUERY.select(:book, :isbn).distinct.from(Settings::BOOKSGRAPH)
		q.where([:book, RDF::REV.hasReview, review_uri])
		q.where([:book, RDF.type, RDF::BIBO.Document])
		q.where([:book, RDF::BIBO.isbn, :isbn])
		REPO.select(q)
	end

end
