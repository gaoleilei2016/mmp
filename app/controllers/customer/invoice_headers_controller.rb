class Customer::InvoiceHeadersController < ApplicationController
	layout "customer"
	skip_before_action :verify_authenticity_token
	def index
		if params[:default]
			# 获取默认发票
			invoice_header = ::Customer::InvoiceHeader.where(user_id:current_user.id,default:'true').first
			render json:{flag:true,invoice_header:invoice_header}
		else
			fas = ::Customer::InvoiceHeader.where(user_id:current_user.id).page(params[:page]).per(params[:per])
			render json:{flag:true,rows:fas,count:fas.count}
		end
	end
	def create
		_d = JSON.parse(params[:invoice_header].to_json)
		_d['user_id'] = current_user.id
		if _d['default'].to_s == 'true'
			::Customer::InvoiceHeader.where(user_id:current_user.id).update_all(default:nil)
		end
		if _d['id']
			invoice_header = ::Customer::InvoiceHeader.find(_d['id'])
			invoice_header.update_attributes(_d)
		else
			invoice_header = ::Customer::InvoiceHeader.new(_d)
		end
		if invoice_header.save
			render json:{flag:true,invoice_header:invoice_header,info:'保存成功'}
		else
			render json:{flag:false,info:"#{invoice_header.errors.messages}"}
		end
	end
	def destroy
		::Customer::InvoiceHeader.find(params[:id]).destroy
		render json:{flag:true,info:'操作成功'}
	end
end
