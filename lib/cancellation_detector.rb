# frozen_string_literal: true

require 'nokogiri'

class CancellationDetector
  include Nokogiri

  def initialize(noko_doc)
    @noko_doc = noko_doc
    cancellation_words = ENV.fetch('CANCELLATION_WORDS', '')
                            .split(',')
                            .map(&:strip)
                            .reject(&:empty?)
    # the (?:..) is a non-capturing group that matches any of the cancellation words
    # \b is word boundary
    @regexs = /\b(?:#{cancellation_words.join('|')})\b/i
  end

  def search
    @noko_doc.css('h1, h2, h3, h4, h5, h6').find { |h| h.text.match?(@regexs) }
  end
end
