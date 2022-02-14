#!/usr/bin/env ruby
require_relative 'lib/pull_from_zephir'
require 'dotenv'
start_time_stamp=`date '+%s'`
Dotenv.load('.env')

PullDailyFromZephir.new.run
begin
  HTTParty.get(ENV.fetch('PUSHMON_URL'))
rescue SocketError => e
  Rails.logger.error("Failed to contact Pushmon; #{e.to_s}")
end

if ENV.fetch('SCRIPT_ENV') == 'production'
  `/usr/local/bin/pushgateway -j search_hathi_trust_daily_pull -b #{start_time_stamp}`
end

