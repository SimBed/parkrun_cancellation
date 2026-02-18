require 'nokogiri'

class WarningFinder
  include Nokogiri
  def initialize(noko, regexs)
    @noko = noko
    @regexs = regexs
  end

  def search
    @noko.css('h1, h2, h3, h4, h5, h6').find { |h| h.text.match?(@regexs) }
  end
end