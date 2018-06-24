# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Thread.new{NoticeChannel.redis.subscribe}