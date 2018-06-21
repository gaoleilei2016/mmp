#encoding:utf-8
class Ims::ReportsController < ApplicationController
	layout 'ims_report'
	# 销售统计
	def sale_report
    @data = Ims::Report.sale_report params.merge({org_id:current_user.organization_id})
    p @data
  end

end