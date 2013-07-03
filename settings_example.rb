require "rdf"

module Settings
	SPARQL_ENDPOINT = "http://example.com/sparql"
	SPARQL_UPDATE_ENDPOINT = "http://example.com/sparql-auth"
	USERNAME = "username"
	PASSWORD = "password"
	BOOKSGRAPH = RDF::URI("http://example.com/books")
	REVIEWSGRAPH = RDF::URI("http://example.com/reviews")
end
