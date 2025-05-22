# frozen_string_literal: true

class Scraper
  def initialize(http_getter, html_parser, entry_parser)
    @http_getter = http_getter
    @html_parser = html_parser
    @entry_parser = entry_parser
  end

  def fetch_entries
    response = @http_getter.get('https://news.ycombinator.com/')
    document = @html_parser.parse(response.body)

    submissions = document.css('tr.athing.submission').map do |submission|
      metadata = submission.next_sibling
      [submission, metadata]
    end

    submissions.map do |submission, metadata|
      @entry_parser.parse_entry(submission, metadata)
    end
  end
end
