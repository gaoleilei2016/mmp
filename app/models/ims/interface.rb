# encoding: utf-8
require'rest_client'
require'json'
require 'rexml/document'
class Ims::Interface
	# j xi  k zhongchengy  l zcy     
	class << self
		def call_webservice method,url,params
			begin
				host_url = localhost #Admin::User.ip(:cmc)
				p "poooooooooooo#{Time.new}oooooooooooooooo"
				p host_url
				rest = RestClient::Resource.new host_url+url,:timeout=>nil,:open_timeout=>nil
				rest.send(method,:params=>params.merge(org_ii:Admin::User.current_user.try(:org_ii)).to_json)
			rescue Exception => e
				print e.message rescue "  e.messag----"
		        print "Erp::Interface.call_webservice  出错 传递参数: #{args}  运行错误: " +"e.backtrace===: "+e.backtrace.join("\n") 
		        {}.to_s
			end
		end

		def send_data attrs
			# get_data = call_webservice :post,"/cthns/api/get_data", attrs
			# JSON.parse get_data
		end

		

	end
end
