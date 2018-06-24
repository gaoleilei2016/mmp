#encoding:utf-8
class Ims::ReportsController < ApplicationController
	layout 'ims_report'
	# 销售统计
	def sale_report
    @data = Ims::Report.sale_report params.merge({org_id:current_user.organization_id})
  end

  # => args = {status:"",hospital:true,detail:nil,delivery_name:nil,factory_name:false,start_time:nil,end_time:nil,org_id:irg_id,current_user:current_user} status:表示发药、退药，hospital：是否是按医院分组，detail：是否查看明细，delivery_name：是否按发药人分组,是否要按生成厂家显示
  
  # 针对医院的: hospital_report
  # 针对发药人的: name_report
  # 针对医院发药人的: hospital_and_name
  # 针对厂家的：drug_by_fact
  # 单独做统计的(药品汇总，药品发药，药品退药) ： drug_report 
  
  # 时间默认1天

  # 处方发药汇总-医院
  # detail 需要查看明细前端传
  def dispensed_hospital
  	@data = Ims::Report.hospital_report params.merge({status:"4",hospital:true,org_id:current_user.organization_id})
  	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @data} }
    end
  end

  # 处方发药汇总-发药人
  def dispensed_name
  	@data = Ims::Report.name_report params.merge({status:"4",delivery_name:true,org_id:current_user.organization_id})
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @data} }
    end
  end

  # 处方发药汇总-医院及发药人
  def dispensed_hospital_and_name
  	@data = Ims::Report.hospital_and_name params.merge({status:"4",hospital:true,delivery_name:true,org_id:current_user.organization_id,type:"hospital_and_name"})
  end

  # 处方发药汇总-发药人及医院
  def dispensed_name_and_hospital
  	@data = Ims::Report.hospital_and_name params.merge({status:"4",hospital:true,delivery_name:true,org_id:current_user.organization_id,type:"name_and_hospital"})
  end

  # 处方退药汇总-医院
  # detail 需要查看明细前端传
  def returned_hospital
  	@data = Ims::Report.hospital_report params.merge({status:"8",hospital:true,org_id:current_user.organization_id})
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @data} }
    end
  end

  # 处方退药汇总-发药人
  def returned_name
  	@data = Ims::Report.name_report params.merge({status:"8",delivery_name:true,org_id:current_user.organization_id})
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @data} }
    end
  end

  # 处方退药汇总-医院及发药人
  def returned_hospital_and_name
  	@data = Ims::Report.hospital_and_name params.merge({status:"8",hospital:true,delivery_name:true,org_id:current_user.organization_id,type:"hospital_and_name"})
  end

  # 处方退药汇总-发药人及医院
  def returned_name_and_hospital
  	@data = Ims::Report.hospital_and_name params.merge({status:"8",hospital:true,delivery_name:true,org_id:current_user.organization_id,type:"name_and_hospital"})
  end

  # 处方药品汇总表(不按发药、退药分)
  def drug_report
  	@data = Ims::Report.drug_report params.merge({org_id:current_user.organization_id})
  	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @data} }
    end
  end

  # 处方发药汇总表
  def drug_dispensed_report
  	@data = Ims::Report.drug_report params.merge({status:"4",org_id:current_user.organization_id})
  end

  # 处方退药汇总表
  def drug_returned_report
  	@data = Ims::Report.drug_report params.merge({status:"8",org_id:current_user.organization_id})
  end

  # 处方发药汇总-厂家
  def drug_dispensed_fact
  	@data = Ims::Report.drug_by_fact params.merge({status:"4",factory_name:true,org_id:current_user.organization_id})
  end

  # 处方退药汇总-厂家
  def drug_returned_fact
  	@data = Ims::Report.drug_by_fact params.merge({status:"8",factory_name:true,org_id:current_user.organization_id})
  end

  # 订单统计(针对未交费、待发药)(时间默认3天)
  # 注意订单状态与处方状态不一致(1:未交费,2:待发药)
  # args ={org_id:'34',start_time:'2018-06-20',end_time:'2018-06-22',status:2,doctor:'',patient_name:'',source_org_id:''}
  def order_static
  	@data = Ims::Report.change_data_report params.merge({org_id:current_user.organization_id})
  end

  # 报表查看明细
  def report_detail
  	@data = Ims::Report.report_detail params.merge({org_id:current_user.organization_id})
    render json:re_data.to_json
  end

end