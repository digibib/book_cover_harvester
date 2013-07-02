require "faraday"
require "nokogiri"

class Resource

	def initialize(isbn)
		@isbn = isbn
		prepare_request
	end

	def check_for_cover_url
		result = Faraday.get(@path+@query_params)
		parse_result(result)
	end

	private

	def prepare_request
		nil
	end

	def parse_result(result)
		raise NotImplementedError
	end

end

class Bokkilden < Resource

	private

	def prepare_request
		@path = "http://partner.bokkilden.no/SamboWeb/partner.do"
		@query_params = "?rom=MP&format=XML&uttrekk=5&pid=0&ept=3&xslId=117&antall=10&enkeltsok=#{@isbn}&profil=partner&sort=popularitet&order=DESC"
	end

	def parse_result(result)
		xml = Nokogiri::XML(result.body)
		xml.xpath('//BildeURL'). map { |url| url.content}
	end

end