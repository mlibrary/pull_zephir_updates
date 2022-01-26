#!/usr/bin/env ruby
require 'httparty'
require 'fileutils'
require 'byebug'

auth =  {:username => ENV.fetch("HT_USERNAME") + "a", :password => ENV.fetch("HT_PASSWORD")}

today = Date.today.strftime("%Y%m%d")
filename = "zephir_upd_#{today}.json.gz"
File.open("./#{filename}", "w") do |file|
  file.binmode
  response = HTTParty.get("#{ENV.fetch("HT_HOST")}/catalog/#{filename}", 
                          basic_auth: auth, 
                          stream_body: true) do |fragment|
    file.write(fragment)
  end
  puts response.code
end
if File.size("./#{filename}") > 0
  FileUtils.mv("./#{filename}", "#{ENV.fetch("TARGET_DIR")}")
else
 puts "File is empty"
end
