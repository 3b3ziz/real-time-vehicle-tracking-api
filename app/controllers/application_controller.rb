# frozen_string_literal: true

class ApplicationController < ActionController::API
  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/my.log")
  end

  def collect_metrics
    start = Time.now
    yield
    duration = Time.now - start
    my_logger.info "#{controller_name}##{action_name}: #{duration}s"
  end
end
