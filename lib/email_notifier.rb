# frozen_string_literal: true

require 'net/smtp'
class EmailNotifier
  # MSP_GMAIL_API_KEY = ENV.fetch('MSP_GMAIL_API_KEY', nil)
  MSP_GMAIL_API_KEY = ENV['MSP_GMAIL_API_KEY']
  def deliver(message)
    msgstr = <<~MESSAGE
      From: membershipsystempro@gmail.com
      To: dansimbed@gmail.com
      Subject: Park Run Cancellation Alert

      Park Run is cancelled this week.
    MESSAGE

    Net::SMTP.start('smtp.gmail.com', 25, 'localhost', 'membershipsystempro@gmail.com', MSP_GMAIL_API_KEY,
                    :login) do |smtp|
      smtp.send_message msgstr, 'membershipsystempro@gmail.com', 'dansimbed@gmail.com'
    end
    puts "Email sent with message: #{message}"
  end
end
