#!/usr/bin/env ruby
require 'httparty'
require 'fileutils'
require 'logger'
require 'byebug'

#Tasks to do:
#Add appropriate logging
#Add another script that gets the full update.
logger = Logger.new(STDOUT)
logger.info("Starting Daily Zephir Pull")
auth =  {:username => ENV.fetch("HT_USERNAME"), :password => ENV.fetch("HT_PASSWORD")}

today = Date.today.strftime("%Y%m%d")
filename = "zephir_upd_#{today}.json.gz"
logger.info("pulling #{filename}")
File.open("./#{filename}", "w") do |file|
  file.binmode
  begin
    response = HTTParty.get("#{ENV.fetch("HT_HOST")}/catalog/#{filename}", 
                            basic_auth: auth, 
                            stream_body: true) do |fragment|
      file.write(fragment)
    end
  rescue SocketError => e
    logger.error(e.to_s)
    return
  end
  if response.code == 200 
    logger.info("Return code: 200") 
  else 
    logger.error("Return code: #{response.code}; Message: #{response.message}")
    return
  end
end

if File.size("./#{filename}") > 0
  begin
    FileUtils.mv("./#{filename}", "#{ENV.fetch("TARGET_DIR")}/")
  rescue => e
    logger.error("failed to move file; #{e.to_s}")
    return
  end
else
  logger.error("#{filename} is empty")
  return
end
logger.info("Finished Script")
begin
  HTTParty.get(ENV.fetch('PUSHMON_URL'))
rescue SocketError => e
  Rails.logger.error("Failed to contact Pushmon; #{e.to_s}")
end
