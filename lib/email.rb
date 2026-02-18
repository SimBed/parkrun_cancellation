# frozen_string_literal: true

require 'net/smtp'
module Email
  # MSP_GMAIL_API_KEY = ENV.fetch('MSP_GMAIL_API_KEY', nil)
  MSP_GMAIL_API_KEY = ENV['MSP_GMAIL_API_KEY']
  def self.send_warning
    msgstr = <<~MESSAGE
      From: Your Name <membershipsystempro@gmail.com>
      To: Destination Address <dansimbed@gmail.com>
      Subject: Park Run Cancellation Alert

      Park Run is cancelled.
    MESSAGE

    Net::SMTP.start('smtp.gmail.com', 25, 'localhost', 'membershipsystempro@gmail.com', MSP_GMAIL_API_KEY,
                    :login) do |smtp|
      smtp.send_message msgstr, 'membershipsystempro@gmail.com', 'dansimbed@gmail.com'
    end
  end
end
