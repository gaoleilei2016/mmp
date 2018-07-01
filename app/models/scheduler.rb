#定时器
#参考https://github.com/jmettraux/rufus-scheduler
class Scheduler
	require 'rufus-scheduler'

	def initialize()
	end

	def self.timer_at(time = "",execute = "")
		scheduler = Rufus::Scheduler.new
		scheduler.at time do
		  eval(execute)
		end
	end

	def self.cron_at(cron = "",execute = "")
		scheduler = Rufus::Scheduler.new
		scheduler.cron cron do
		  eval(execute)
		end
	end
end