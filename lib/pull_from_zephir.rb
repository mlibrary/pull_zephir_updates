require 'httparty'
require 'fileutils'
require 'logger'
require 'byebug'
class PullFromZephir
  def run
    logger = Logger.new(STDOUT)
    logger.info("Starting Script")
    logger.info("pulling #{filename} from #{ENV.fetch("HT_HOST")}")
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

    file_size = File.size("./#{filename}")
    logger.info "File size for #{filename} is #{file_size} bytes"
    if file_size > 0
      begin
        FileUtils.mv("./#{filename}", "#{target_dir}/")
      rescue => e
        logger.error("failed to move file to #{target_dir}; #{e.to_s}")
        return
      end
      logger.info("Moved #{filename} to #{target_dir}")
    else
      logger.error("#{filename} is empty")
      return
    end
    logger.info("Finished Script")
  end
  private
  def auth
   {:username => ENV.fetch("HT_USERNAME"), :password => ENV.fetch("HT_PASSWORD")}
  end
  def target_dir
    ENV.fetch("TARGET_DIR")
  end
  def filename
    #parent class
  end
  def format_date(date)
    date.strftime("%Y%m%d")
  end
end

class PullDailyFromZephir < PullFromZephir
  def filename 
    "zephir_upd_#{format_date(Date.today)}.json.gz"
  end
end
class PullFullFromLastMonthFromZephir < PullFromZephir
  def filename
    prev_month = Date.today.prev_month
    last_day_of_last_month = Date.new(prev_month.year, prev_month.month, -1)
    "zephir_full_#{format_date(last_day_of_last_month)}_vufind.json.gz"
  end
end
