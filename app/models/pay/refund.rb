#encoding: utf-8

class Pay::Refund < ApplicationRecord
  self.table_name = 'pay_refunds'

  # out_refund_no,refund_fee,status,status_desc,reason
  validates_presence_of :out_refund_no, message: '退款单号不能为空'
  validates_presence_of :refund_fee,    message: '退款金额不能为空'

  validates_uniqueness_of :out_refund_no, message: '订单号必须唯一'

  belongs_to :order, class_name: 'Pay::Order', optional: true

  # status:=>{fail: '请求失败',com:'保存成功',succ:'退款提交成功,等待退款',
  # error: '参数、创建记录、系统错误', success:'已退款', abnormal: '异常:如金额不等;退款不成功'}
  class << self
    # args={out_refund_no: '退款单号', refund_fee: '金额', reason: '原因',out_trade_no:'订单号'}
    def carry_out(args)
      begin
        return write_log_return({state: :error, msg: '无效的金额', desc: '退款金额必须大于等于0.01'}) unless args[:refund_fee].to_f >= 0.01
        ord = Pay::Order.find_by(out_trade_no: args[:out_trade_no])
        return write_log_return({state: :error, msg: '参数错误', desc: '退款对应的订单不存在'}) unless ord
        # return write_log_return({state: :fail, msg: '订单未支付', desc: '原始订单未支付无法退款, 若有异常请联系管理员'}) unless ord.paid?
        ref = find_by(out_refund_no: args[:out_refund_no]) #查找退款订单
        return write_log_return({state: :fail, msg: '已退款', desc: '订单已退款'}) if ref&.status&.eql?('success')
        return handle_refund_app(ref) if ref  #如果找到就直接退款
        ref = new({out_refund_no: args[:out_refund_no], refund_fee: args[:refund_fee], reason: args[:reason], order: ord, status: 'com', status_desc: '保存成功'})
        return write_log_return({state: :error, msg: '退款记录保存出错', desc: ref.errors.full_messages.join(',')}) unless ref.save
        handle_refund_app(ref)
      rescue Exception => e
        write_log_return({state: :error, msg: '系统错误', desc: e.message})
      end
    end

    def handle_refund_app(ref)
      return Pay::Wechat.refund(ref) if ref.order.pay_type.eql?('wechat')
      Pay::Alipay.refund(ref)
    end

    # args={out_refund_no: '退款单号'}
    def restart(args)
      write_log_return({state: :start, msg: '重新退款开始', desc: args.to_json})
      refund = find_by(out_refund_no: args[:out_refund_no])
      # return write_log_return({state: :error, msg: '参数错误',})
    end

    def query_res()
    end

    def write_log_return(args)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'refund'})
      args
    end
  end

  # 是否已退款
  def refunded?
    status.eql?('success')
  end
end