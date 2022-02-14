#!/usr/bin/env ruby
require_relative 'lib/pull_from_zephir'
require 'dotenv'
start_time_stamp=`date '+%s'`
Dotenv.load('.env')

PullFullFromLastMonthFromZephir.new.run

if ENV.fetch('SCRIPT_ENV') == 'production'
  `/usr/local/bin/pushgateway -j search_hathi_trust_monthly_pull -b #{start_time_stamp}`
end
