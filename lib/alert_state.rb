module AlertState
  PROJECT_ROOT = File.expand_path('..', __dir__) # /home/..../parkrun
  STATE_DIR = File.join(PROJECT_ROOT, 'state') # /home/...../parkrun/state
  def flag_path
    File.join(STATE_DIR, "#{current_event_key}.sent") # /home/..../parkrun/state/2026-W8.sent
  end

  def current_event_key
    today = Date.today
    "#{today.year}-W#{today.cweek}" # "2026-W7"
  end
end

