# frozen_string_literal: false

require 'active_support/all'
require_relative 'website_requester'
require_relative 'warning_finder'
require_relative 'state_recorder'
require_relative 'twilio_message'
require_relative 'email'
require_relative 'notifier'
require_relative 'email_notifier'
require_relative 'whatsapp_notifier'
# require 'byebug'


class CancellationMonitor
  # include Email
  def initialize(url:, regexs:, notifier:, test: false)
    @url = url
    @regexs = regexs
    @notifier = notifier
    @test = test
  end

  def run
    @date = Time.now.strftime('%d/%m/%Y %H:%M')
    noko = WebsiteRequester.new(@url).request
    manage_warnings(@date, warning_find(noko))
  end

  def warning_find(noko)
    WarningFinder.new(noko, @regexs).search
  end

  def manage_warnings(date, warning_find)
    if warning_find
      # Email.send_warning
      # TwilioMessage.new(content_variables: { '1': date, '2': 'Watford' }).send_whatsapp
      issue_notification_warnings
      StateRecorder.new.record_notifications_sent
      puts "Warning found and recorded that it has been issued. Alert: #{warning_find.text} at #{date}"
    elsif @test
      puts "Test mode: No alert found at #{date}"
    end
    # TwilioMessage.new(content_variables: { '1': date, '2': warning_find }).send_whatsapp
  end

  private

  def issue_notification_warnings
    content_variables =  { '1': @date, '2': 'Watford' }
    @notifier.notify(content_variables:)
  end

end

