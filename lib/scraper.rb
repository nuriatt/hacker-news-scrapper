# frozen_string_literal: true

require_relative 'entry'
require_relative 'html_parser'
require_relative 'http_getter'
require_relative 'entry_parser'
require_relative 'title_filter'

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

http_getter = HTTPGetter.new
html_parser = HTMLParser.new
entry_parser = EntryParser.new

scraper = Scraper.new(http_getter, html_parser, entry_parser)

entries = scraper.fetch_entries

more_than_five = TitleFilter.new(entries).more_than_five_words

puts 'MORE THAN 5 WORDS'
puts '================='

more_than_five.each { |entry| puts entry.title }

puts "\n"
puts 'LESS THAN 5 WORDS'
puts '================='

less_than_five = TitleFilter.new(entries).less_than_five_words

less_than_five.each { |entry| puts entry.title }
