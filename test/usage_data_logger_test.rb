# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'time'
require_relative '../lib/usage_data_logger'

class TestUsageDataLogger < Minitest::Test
  def setup
    @test_log_file = 'test_usage_data.json'
    FileUtils.rm_f(@test_log_file)
    @usage_data_logger = UsageDataLogger.new(@test_log_file)
  end

  def teardown
    FileUtils.rm_f(@test_log_file)
  end

  def test_initialization_creates_empty_log_file
    assert File.exist?(@test_log_file)
    content = File.read(@test_log_file)
    assert_equal '[]', content.strip
  end

  def test_log_request_adds_new_entry
    logs_before = JSON.parse(File.read(@test_log_file))

    @usage_data_logger.log_request('more_than_five_words')
    logs_after = JSON.parse(File.read(@test_log_file))

    assert_equal 0, logs_before.length
    assert_equal 1, logs_after.length

    assert_equal 'more_than_five_words', logs_after[0]['filter_type']
    assert logs_after[0]['timestamp'].is_a?(Integer)
    assert Time.parse(logs_after[0]['date']).is_a?(Time)
  end

  def test_get_stats_returns_correct_counts
    @usage_data_logger.log_request('more_than_five_words')
    @usage_data_logger.log_request('less_than_or_equal_to_five_words')
    @usage_data_logger.log_request('less_than_or_equal_to_five_words')

    stats = @usage_data_logger.get_stats
    assert_equal 1, stats['more_than_five_words']
    assert_equal 2, stats['less_than_or_equal_to_five_words']
  end

  def test_load_logs_handles_invalid_json
    File.write(@test_log_file, 'invalid json')
    logs = @usage_data_logger.send(:load_logs)
    assert_equal [], logs
  end

  def test_log_request_preserves_existing_entries
    @usage_data_logger.log_request('more_than_five_words')
    logs_before = JSON.parse(File.read(@test_log_file))

    @usage_data_logger.log_request('less_than_or_equal_to_five_words')
    logs_after = JSON.parse(File.read(@test_log_file))

    assert_equal 1, logs_before.length
    assert_equal 2, logs_after.length
    assert_equal 'more_than_five_words', logs_after[0]['filter_type']
    assert_equal 'less_than_or_equal_to_five_words', logs_after[1]['filter_type']
  end

  def test_get_stats_returns_empty_hash_when_no_logs
    stats = @usage_data_logger.get_stats
    assert_empty stats
  end
end
