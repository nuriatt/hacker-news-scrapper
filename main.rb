# frozen_string_literal: true

require_relative 'lib/entry_parser'
require_relative 'lib/entry'
require_relative 'lib/html_parser'
require_relative 'lib/http_getter'
require_relative 'lib/scraper'
require_relative 'lib/title_filter'
require_relative 'lib/usage_data_logger'

class HackerNewsScraperCLI
  def initialize
    @http_getter = HTTPGetter.new
    @html_parser = HTMLParser.new
    @entry_parser = EntryParser.new
    @scraper = Scraper.new(@http_getter, @html_parser, @entry_parser)
    @usage_data_logger = UsageDataLogger.new
  end

  def run
    loop do
      display_menu
      choice = gets.chomp

      case choice
      when '1'
        display_entries(@scraper.fetch_entries)
      when '2'
        entries = @scraper.fetch_entries
        filtered = TitleFilter.new(entries).more_than_five_words
        @usage_data_logger.log_request('more_than_five_words')
        display_entries(filtered)
      when '3'
        entries = @scraper.fetch_entries
        filtered = TitleFilter.new(entries).less_than_or_equal_to_five_words
        @usage_data_logger.log_request('less_than_or_equal_to_five_words')
        display_entries(filtered)
      when '4'
        stats = @usage_data_logger.get_stats
        puts "\nFilter usage statistics:\n\n"
        stats.each do |filter_type, count|
          puts "Filter: #{filter_type} || used #{count} times"
        end
      when '5'
        puts "\nSee you soon!\n\n"
        break
      else
        puts "\nPlease, choose a number between 1 and 5."
      end

      puts "\nPress Enter to continue...\n"
      gets
    end
  end

  private

  def display_menu
    system 'clear'
    puts '******************************************'
    puts '*** WELCOME TO THE HACKER NEWS SCRAPER ***'
    puts '******************************************'
    puts "\nWhat do you want to do?\n\n"
    puts '1. View all entries'
    puts '2. Filter entries with more than 5 words (sorted by comments)'
    puts '3. Filter entries with 5 or less words (sorted by points)'
    puts '4. View filter usage statistics'
    puts '5. Exit'
    print "\nEnter your choice (1-5): "
  end

  def display_entries(entries)
    entries.each do |entry|
      puts "Rank: #{entry.rank}"
      puts "Title: #{entry.title}"
      puts "Points: #{entry.score}"
      puts "Comments: #{entry.comments}"
      puts '--------------------------------'
    end
  end
end

HackerNewsScraperCLI.new.run
