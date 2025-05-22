# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/entry'

class TestEntry < Minitest::Test
  def setup
    @entry = Entry.new(1, 6, 'Entry Title', 42, 10)
  end

  def test_attributes_are_accessible
    assert_equal 1, @entry.id
    assert_equal 6, @entry.rank
    assert_equal 'Entry Title', @entry.title
    assert_equal 42, @entry.score
    assert_equal 10, @entry.comments
  end

  def test_attributes_are_read_only
    assert_raises(NoMethodError) { @entry.id = 2 }
    assert_raises(NoMethodError) { @entry.rank = 9 }
    assert_raises(NoMethodError) { @entry.title = 'New Entry Title' }
    assert_raises(NoMethodError) { @entry.score = 100 }
    assert_raises(NoMethodError) { @entry.comments = 5 }
  end
end
