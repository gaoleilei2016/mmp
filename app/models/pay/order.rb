#encoding: utf-8

class Pay::Data < ApplicationRecord
  self.table_name = 'pay_orders'

  validates_presence_of :out_trade_no, message: '订单号不能为空'
  validates_presence_of :total_fee,    message: '订单金额不能为空'
  validates_presence_of :title,        message: '订单标题不能为空'
  validates_presence_of :pay_type,     message: '支付类型必须存在'

  validates_inclusion_of :pay_type, :in => %w{alipay wechat}, :message => '目前只支持微信和支付宝支付'

  has_many :deps, class_name: 'Pay::Refund'
  # status:=>{fail: '订单提交时出错或参数错误',succ:'订单提交成功,等待支付',
  #   success:'已支付',ref_err:'退款出错', ref_succ:'退款成功'}
  # 是否已支付
  def paid?
    status.eql?('success')
  end

  # 是否已退款
  def refunded?
    status.eql?('ref_succ')
  end
end