# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'httparty'

require_relative '../lib/http_getter'

class TestHTTPGetter < Minitest::Test
  def setup
    @http_getter = HTTPGetter.new
  end

  def test_get_makes_an_http_get_request
    url = 'https://news.ycombinator.com/'
    response = stub(body: '<html>Mocked</html>')

    HTTParty.expects(:get).with(url).returns(response)

    result = @http_getter.get(url)

    assert_equal '<html>Mocked</html>', result.body
  end
end
