#!/usr/bin/env ruby
require_relative 'lib/pull_from_zephir'

PullDailyFromZephir.new.run
begin
  HTTParty.get(ENV.fetch('PUSHMON_URL'))
rescue SocketError => e
  Rails.logger.error("Failed to contact Pushmon; #{e.to_s}")
end
