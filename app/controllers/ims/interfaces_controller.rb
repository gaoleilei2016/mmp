# encoding:utf-8
# 药店-接口
class Ims::InterfacesController < Admin::User::SessionsController
  prepend_before_filter :allow_params_authentication!, only: [:create,:hr_interface]
  prepend_before_filter only: [ :create, :destroy ,:hr_interface] { request.env["devise.skip_timeout"] = true }

  #
  def common_interface
    resources = RestClient::Resource.new "http://#{::Admin::User.ip(:cmc)}/interfaces/get_session_data.json?session_id="+params[:session_id].to_s #'http://199.199.199.233:3000/hr/hr_interfaces/organizations.json'
    json = JSON.parse(resources.get) 
    render json:json
  end

  # 订单
  def receive_order
    response.headers['Access-Control-Allow-Origin'] = '*'
    departments = RestClient::Resource.new "http://#{::Admin::User.ip(:cmc)}/hr/hr_interfaces/departments.json?org_ii="+current_user.org_ii #'http://199.199.199.233:3000/hr/hr_interfaces/organizations.json'
    deps = JSON.parse(departments.get) 
    Erp::Setting::Department.create_departments deps,current_user.org_ii
    # if json['flag']
    #   depInfo = json['data'].deep_symbolize_keys!
    #   p depInfo
    #   redirect_to params[:path].present? ? params[:path] : "/"
    # else
    #   render json:json
    # end
    render json:{flag:true,info:"获取成功！"}
  end
  
end