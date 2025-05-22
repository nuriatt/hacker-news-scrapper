# frozen_string_literal: true

require 'httparty'

class HTTPGetter
  def get(url)
    HTTParty.get(url)
  end
end
