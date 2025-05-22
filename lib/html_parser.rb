# frozen_string_literal: true

require 'nokogiri'

class HTMLParser
  def parse(body)
    Nokogiri::HTML(body)
  end
end
