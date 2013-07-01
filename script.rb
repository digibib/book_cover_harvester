require "rdf"
require "rdf/virtuoso"
require "faraday"
require "./vocabularies.rb"
require "./settings.rb"

sparql_endpoint = "http://marc2rdf.deichman.no/sparql"
sparql_update_endpoint = "http://marc2rdf.deichman.no/sparql-auth"
username = "rdfstore"
password = "rdf99store"

REPO = RDF::Virtuoso::Repository.new(Settings::SPARQL_ENDPOINT,
									:update_uri => Settings::SPARQL_UPDATE_ENDPOINT,
									:username => Settings::USERNAME,
									:password => Settings::PASSWORD,
									:auth_method => 'digest')
QUERY = RDF::Virtuoso::Query

q = QUERY.select(:review).distinct
q.where([:book, RDF::REV.hasReview, :review],)
q.where([:book, RDF.type, RDF::BIBO.Document])
q.minus([:book, RDF::FOAF.depiction, :cover_url])

res =  REPO.select(q)

res.bindings



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