class NoticeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notice_channel"
    p "========================="
    p "链接成功"
    p params
    p "========================="
  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def say(data)
    p "channel________________+"
    p data
    p "channel+++++++++++++++++-"
    Ims::Order.order_message data
  end
end
