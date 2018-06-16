# encoding:utf-8
# 药店-接口
class Ims::InterfacesController < Admin::User::SessionsController
  prepend_before_filter :allow_params_authentication!, only: [:create,:hr_interface]
  prepend_before_filter only: [ :create, :destroy ,:hr_interface] { request.env["devise.skip_timeout"] = true }

  #
  def common_interface
    resources = RestClient::Resource.new "http://#{localhost}/interfaces/get_session_data.json?session_id="+params[:session_id].to_s #'http://199.199.199.233:3000/hr/hr_interfaces/organizations.json'
    json = JSON.parse(resources.get) 
    render json:json
  end

  # 订单接收
  def receive_order
    response.headers['Access-Control-Allow-Origin'] = '*'
    # departments = RestClient::Resource.new "http://#{localhost}/hr/hr_interfaces/departments.json?org_ii="+current_user.org_ii #'http://199.199.199.233:3000/hr/hr_interfaces/organizations.json'
    received = Ims::Order.receive_order params
    render json:received.to_json
  end
  
end