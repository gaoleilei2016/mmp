#encoding: utf-8

class Pay::Order < ApplicationRecord
  self.table_name = 'pay_orders'

  validates_presence_of :out_trade_no, message: '订单号不能为空'
  validates_presence_of :total_fee,    message: '订单金额不能为空'
  validates_presence_of :title,        message: '订单标题不能为空'
  validates_presence_of :pay_type,     message: '支付类型必须存在'

  validates_presence_of :openid, message: 'openid必须存在', :if => :public_openid

  validates_uniqueness_of :out_trade_no, message: '订单号必须唯一'
  validates_inclusion_of :pay_type, :in => %w{alipay wechat}, :message => '目前只支持微信和支付宝支付'

  has_many :refunds, class_name: 'Pay::Refund'
  # status:=>{fail: '订单提交时出错或参数错误',succ:'订单提交成功,等待支付',
  #   success:'已支付',refund:'有退款', abnormal: '异常:如金额不等；未支付'}
  
  # cost_name(费用类别),
  # return_url(支付后返回路径)
  # status(订单状态 为success时是已支付)
  # status_desc(订单状态描述)
  scope :recent, ->{order(created_at: :desc)}

  class << self
    # args={out_trade_no:'订单号'}
    def query_res(args)
    end
  end

  def user_health_expired
    user = User.find_by(openid: openid)
    return {state: :notfund, msg: '用户未找到', desc: "--------未找到[#{openid}]对应的用户"} unless user
    ex = Time.now.next_day.to_s
    return {state: :succ, msg: '用户已支付', desc: "-----#{user.login}用户的健康二维码有效期为#{ex}"} if user.update_attributes({expired_in: ex})
    {state: :error, msg: '更新有效期失败', desc: "-----#{user.login}用户的健康二维码有效期更新失败: #{user.errors.full_messages.join(',')}"}
  end

  def public_openid
    return true if trade_type.eql?('JSAPI')
    false
  end

  # 是否已支付
  def paid?
    status.eql?('success')
  end
end