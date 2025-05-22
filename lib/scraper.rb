# frozen_string_literal: true

require_relative 'entry'
require_relative 'html_parser'
require_relative 'http_getter'

class Scraper
  def initialize(http_getter, html_parser)
    @http_getter = http_getter
    @html_parser = html_parser
  end

  def fetch_entries
    response = @http_getter.get('https://news.ycombinator.com/')
    document = @html_parser.parse(response.body)

    submissions = document.css('tr.athing.submission').map do |submission|
      metadata = submission.next_sibling
      [submission, metadata]
    end

    submissions.map do |submission, metadata|
      id = submission.attribute('id').value
      rank = submission.css('span.rank').first.children.first.text.chomp('.').to_i
      title = submission.css('span.titleline').first.children.first.text

      score = metadata.css('span.score')
      score = score.empty? ? 0 : score.first.children.first.text.chomp(' points').to_i

      comments = metadata.css('a').at('a:contains("comments")')
      comments = comments.nil? ? 0 : comments.children.text.chomp(' comments').to_i

      entry = Entry.new(id, rank, title, score, comments)

      puts entry.title

      entry
    end
  end
end

http_getter = HTTPGetter.new
html_parser = HTMLParser.new

scraper = Scraper.new(http_getter, html_parser)
scraper.fetch_entries
