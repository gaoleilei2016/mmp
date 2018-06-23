#encoding: utf-8

require 'redis'

$redis = Redis.new

class NoticeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "notice_channel"
    p "========================="
    p "链接成功"
    p params
    p "========================="
    stream_from self.class.ch_name(current_user[:uid])
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

  class << self
    # 发送消息
    # msg = {type: '类型', event: '事件', content: '内容', ch: '药店ID'}
    def send_message(msg)
      data = msg['msg']
      name = data['ch']
      data.delete('ch')
      ActionCable.server.broadcast ch_name(name), data
    end

    def publish(msg)
      data = {redis: {publish: true}}
      num = $redis.publish('message_redis_queue', data.merge({msg: msg}).to_json)
      return {state: :succ, msg: '发送成功'} if num.eql?(1)
      return {state: :error, msg: '消息发送失败'} if num.eql?(0)
      {state: :abnormal, msg: '有部分进程异常,没有收到消息'}
    end

    def redis
      MsgRedisClient.new
    end

    # 队列命名规则
    def ch_name(name)
      "message_#{name}"
    end
  end

  class MsgRedisClient
    # 启动时调用，订阅消息
    def subscribe
      p '00000000000000000000000000000000000'
      $redis.subscribe(queue_name) do |on|
        on.message do |ch, msg|
          NoticeChannel.send_message(JSON.parse(msg))
        end
      end
    end

    # redis队列名称
    def queue_name
      'message_redis_queue'
    end
  end
end
