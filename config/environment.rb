# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
# ::Orders::Order.check_order_timer

Thread.new{NoticeChannel.redis.subscribe}