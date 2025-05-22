# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/html_parser'

class TestHTMLParser < Minitest::Test
  def setup
    @parser = HTMLParser.new
  end

  def test_parse_returns_nokogiri_document
    html = '<html><body><h1>Hello</h1></body></html>'
    document = @parser.parse(html)

    assert_instance_of Nokogiri::HTML::Document, document
    assert_equal 'Hello', document.at('h1').text
  end
end
