#encoding: utf-8

class Pay::Refund < ApplicationRecord
  self.table_name = 'pay_refunds'

  # out_refund_no,refund_fee,status,status_desc

end