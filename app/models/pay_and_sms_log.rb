#encoding: utf-8

require 'logger'

# 关于支付的日志记录
class PayAndSmsLog < Logger
  def initialize(args = {})
    # file_root = args[:file_root] || logger_root
    file_root = args[:file_name].nil? ? logger_root : logger_root(args[:file_name])
    cycle = args[:cycle] || 'weekly'
    super(file_root, cycle)
  end

  def logger_root(file_name = 'pay')
    dir_root = "#{File.expand_path('../../../', __FILE__)}/log/#{Time.now.year}-#{Time.now.month}"
    Dir.mkdir(dir_root) unless Dir.exist?(dir_root)
    "#{dir_root}/#{file_name}_#{DateTime.now.cweek}.log"
  end

  def format_message(serverity, timestamp, progname, msg)
    "$$:#{progname}-=-#{timestamp.to_formatted_s(:db)}-=-#{serverity}--: #{msg} \n \n"
  end

  class << self
    def info(msg, args = {})
      log = self.new(args)
      log.info(msg)
    end
  end
end