# frozen_string_literal: false
require_relative 'alert_state'

class StateRecorder
  include AlertState
  def already_sent?
    File.exist?(flag_path)
  end

  def record_notifications_sent
    File.write(flag_path, Time.now.to_s)
  end
end