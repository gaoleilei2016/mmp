class Scheduler
	require 'rufus-scheduler'

	def initialize()
		@scheduler = Rufus::Scheduler.new
	end

	def timer_at(time = "",execute = "")
		@scheduler.at time do
		  eval(execute)
		end
	end
end