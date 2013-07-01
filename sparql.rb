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
		q = QUERY.select(:review).distinct
		q.where([:book, RDF::REV.hasReview, :review],)
		q.where([:book, RDF.type, RDF::BIBO.Document])
		q.minus([:book, RDF::FOAF.depiction, :cover_url])
		REPO.select(q).bindings[:review]
	end

end
