require "grape"
class Ims::Api #< Grape::API
    version 'v1', :using => :header, :vendor => 'Erp'
    format :json

    helpers do
      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    # 订单
    resource :get_order_data do  
      desc "Return a person information."
      params do
        requires :id, :type => String, :desc => "Person id."
        requires :attrs, :type => String, :desc =>"data info"
      end
      get 'id' do
      end
      post do
        begin
          time1 = Time.new
          data = JSON.parse(params.params) 
          # {:data=>{:patient=>{:code=>"172060", :name=>"张秋霞", :payment_type=>"新型农村合作医疗", :patient_type=>"", :age=>"29years old", :sex=>"女性", :department=>"妇产科", :diagnosis=>{:code=>"O00_1", :display_name=>"异位妊娠"}, :address=>""}, :biller=>{:biller_department=>"妇产科", :biller_author=>"陈帮涛"}, :performer=>{:performer_operator=>"", :performer_location=>""}, :medical_source=>{:id=>"Y2580", :display_name=>"258号药房"}, :drugs=>{:code=>"1527", :name=>"注射用托拉塞米    10mg        ", :total=>{:value=>"1", :unit=>"瓶"}, :price=>"21.65", :unit=>"瓶", :modifier_code=>"J"}}, :org_ii=>"2.16.156.1.429280623"}
          # 医嘱接收
          p data
          result = Ims::OrderHeader.receive_order data
          p "receive_order===#{Time.new}=====end======订单的接收 耗时：===#{Time.new-time1}==========="
          p result
        rescue Exception => e
          print "订单的接收 api 出错："+e.backtrace.join("\n") 
          {}
        end
      end
      put do
        begin
          
        rescue Exception => e
          print " api 出错："+e.backtrace.join("\n") 
          {}
        end
      end
    end

end