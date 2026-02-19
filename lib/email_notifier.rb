# frozen_string_literal: true

require 'net/smtp'
class EmailNotifier
  GMAIL_API_KEY = ENV.fetch('GMAIL_API_KEY', nil)
  EMAIL_FROM = ENV.fetch('EMAIL_FROM', nil)
  EMAIL_TO = ENV.fetch('EMAIL_TO', nil)
  def deliver(attributes)
    msgstr = <<~MESSAGE
      From: #{EMAIL_FROM}
      To: #{EMAIL_TO} 
      Subject: Park Run Cancellation Alert

      Park Run at #{attributes[:content_variables][:'1']} is cancelled this week on #{attributes[:content_variables][:'2']}.
    MESSAGE

    Net::SMTP.start('smtp.gmail.com', 25, 'localhost', EMAIL_FROM, GMAIL_API_KEY,
                    :login) do |smtp|
      smtp.send_message msgstr, EMAIL_FROM, EMAIL_TO
    end
  end
end
