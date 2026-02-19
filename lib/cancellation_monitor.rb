# frozen_string_literal: false

require 'active_support/all'
require_relative 'website_requester'
require_relative 'cancellation_detector'
require_relative 'state_recorder'
require_relative 'notifier'
require_relative 'email_notifier'
require_relative 'whatsapp_notifier'
# require 'byebug'

class CancellationMonitor
  # include Email
  def initialize(url:, notifier:)
    @url = url
    @notifier = notifier
    @park_name = ENV['PARK_NAME'].capitalize
    manage_date_and_time
  end

  def run
    noko_doc = WebsiteRequester.new(@url).request
    cancellation_detection = CancellationDetector.new(noko_doc).search
    manage_notifications(cancellation_detection)
  end

  def manage_notifications(cancellation_detection)
    if cancellation_detection
      issue_notification_warnings
      StateRecorder.new.record_notifications_sent
      puts "Cancellation indication found and recorded to file that notification has been issued. \n Indication heading found: #{cancellation_detection.text} at #{@park_name} at #{@time}"
    else
      puts "No indication of cancellation found at #{@park_name} at #{@time}"
    end
  end

  private

  def issue_notification_warnings
    content_variables = { '1': @park_name, '2': @date  }
    @notifier.notify(content_variables:)
  end

  def manage_date_and_time
    time = Time.now
    @time = time.strftime('%d/%m/%Y %H:%M')
    @date = time.strftime('%d %b %Y')
  end
end
