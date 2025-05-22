# frozen_string_literal: true

require 'json'

class UsageDataLogger
  def initialize(log_file = 'usage_data.json')
    @log_file = log_file
    create_log_file unless File.exist?(@log_file)
  end

  def log_request(filter_type)
    logs = load_logs
    logs << {
      timestamp: Time.now.to_i,
      filter_type: filter_type,
      date: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    }
    save_logs(logs)
  end

  def get_stats
    logs = load_logs
    logs.group_by { |log| log['filter_type'] }
        .transform_values(&:count)
  end

  private

  def create_log_file
    save_logs([])
  end

  def load_logs
    JSON.parse(File.read(@log_file))
  rescue JSON::ParserError
    []
  end

  def save_logs(logs)
    File.write(@log_file, JSON.pretty_generate(logs))
  end
end
