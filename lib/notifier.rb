# frozen_string_literal: true

class Notifier
  def initialize(channels:)
    @channels = channels
  end

  def notify(content_variables)
    @channels.each { |channel| channel.deliver(content_variables) }
  end
end
