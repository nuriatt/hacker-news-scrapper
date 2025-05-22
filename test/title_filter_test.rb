# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/entry'
require_relative '../lib/title_filter'

class TestTitleFilter < Minitest::Test
  def setup
    @entries = [
      Entry.new(1, 9, 'Two words', 100, 10),
      Entry.new(2, 30, 'This is exactly five words', 50, 20),
      Entry.new(3, 8, 'This one has more than five words exactly nine', 10, 99),
      Entry.new(5, 1, 'This is - a self-explained example', 25, 30),
      Entry.new(6, 1, 'This is another title longer than five words', 25, 30),
      Entry.new(7, 25, 'This has ! and ? and ()', 77, 39),
      Entry.new(8, 23, 'Fast Allocations in Ruby 3.5', 12, 45),
      Entry.new(9, 7, 'The Philosophy of Byung-Chul Han (2020)', 142, 75)
    ]
    @filter = TitleFilter.new(@entries)
  end

  def test_more_than_five_words_returns_titles_with_more_than_five_words
    result = @filter.more_than_five_words
    assert_equal 3, result.size
    assert_equal 'This one has more than five words exactly nine', result.first.title
  end

  def test_more_than_five_words_returns_titles_sorted_by_comments
    result = @filter.more_than_five_words
    assert_equal 3, result.size
    assert_equal 99, result[0].comments
    assert_equal 75, result[1].comments
    assert_equal 30, result[2].comments
  end

  def test_less_than_or_equal_to_five_words_returns_titles_with_less_than_or_equal_to_five_words
    result = @filter.less_than_or_equal_to_five_words
    assert_equal 5, result.size
    assert_equal 'Two words', result.first.title
  end

  def test_less_than_or_equal_to_five_words_returns_titles_sorted_by_score
    result = @filter.less_than_or_equal_to_five_words
    assert_equal 5, result.size
    assert_equal 100, result[0].score
    assert_equal 77, result[1].score
    assert_equal 50, result[2].score
    assert_equal 25, result[3].score
    assert_equal 12, result[4].score
  end
end
