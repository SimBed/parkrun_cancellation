#!/home/simbed/.rbenv/shims/ruby

# get the shebang line from $which ruby
# make this file executable with  $chmod +x octopus_spike_warn.rb
# dont include the ruby command in the cron (just the full file path)
# for environment variables to pass, add the profile in the cron
# . ~/.profile && ~/myscripts/energy-spike/octopus_spike_warn.rb
# the . (single dot) is short-hand for source)

require_relative 'octopus.rb'

octopus = Octopus.new(OCTOPUS_SECRETS, TWILIO_SECRETS).alert_check