#!/usr/bin/bash

source ~/.profile
cd ~/environment/non-rails-apps/energy-spike
# 2>&1 means redirect stderr to stdout, so both will be logged in the same file
# use full path to ruby to ensure the correct version is used in the cron environment (and so any require statements don't fail eg because a gem needed is not installed in the system ruby)
/home/simbed/.rbenv/shims/ruby octopus_spike_warn.rb >> "script.log" 2>&1