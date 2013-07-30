# encoding: utf-8
require "faraday"
require "nokogiri"
require "digest"

class Resource

  def initialize(isbn, bibid)
    @isbn = isbn
    @bibid = bibid
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
    res = xml.xpath('//BildeURL').map{ |url| url.content}.map{ |url| url.sub(/&width=80$/, '')}
    filter_dummy_pictures(res)
  end

  def filter_dummy_pictures(res)
    res.delete_if do |result|
      img = Faraday.get(result).body
      hash = Digest::MD5.hexdigest(img)
      true if hash == "0a993cc6694e9249965e626eb4e037c7"
    end
  end
end

class Katalogkrydder < Resource

  private

  def prepare_request
    @path = "http://krydder.bibsyst.no/cgi-bin/krydderxml"
    @query_params = "?bid=#{@bibid}"
  end

  def parse_result(result)
    xml = Nokogiri::XML(result.body)
    xml.xpath('//xmlns:størrelse[contains(text(), "stor")]/../xmlns:url').map { |url| url.text}
  end
end
