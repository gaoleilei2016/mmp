#encoding:utf-8
class Ims::OrdersController < ApplicationController
  before_action :set_ims_order, only: [:show, :edit, :update, :destroy]

  # GET /ims/orders
  # GET /ims/orders.json
  def index
    @ims_orders = Ims::Order.order_search params
  end

  # GET /ims/orders/1
  # GET /ims/orders/1.json
  def show
  end

  # GET /ims/orders/new
  def new
    @ims_order = Ims::Order.new
  end

  # GET /ims/orders/1/edit
  def edit
  end

  # POST /ims/orders
  # POST /ims/orders.json
  def create
    @ims_order = Ims::Order.new(ims_order_params)

    respond_to do |format|
      if @ims_order.save
        format.html { redirect_to @ims_order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @ims_order }
      else
        format.html { render :new }
        format.json { render json: @ims_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/orders/1
  # PATCH/PUT /ims/orders/1.json
  def update
    respond_to do |format|
      if @ims_order.update(ims_order_params)
        format.html { redirect_to @ims_order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_order }
      else
        format.html { render :edit }
        format.json { render json: @ims_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/orders/1
  # DELETE /ims/orders/1.json
  def destroy
    @ims_order.destroy
    respond_to do |format|
      format.html { redirect_to ims_orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def order_settings
    respond_to do |format|
      format.html{render "/ims/home/temp"}
      format.json{}
    end
  end

  def get_orders
    #搜索平台的 订单 处方
    case params[:stat].to_s
    when '1' #未交费
      type = "1"
    when '2' #待发药
      type = "2"
    when '5' #已发药
      type = "5"
    when '7' #已退药
      type = "7"
    else
      type = "9999"
    end
    if params[:platform]
      @data = Orders::Order.get_order_to_medical({type:type,org_id:current_user.try(:organization_id)})
    end
    #搜索药店的 订单 处方
    if params[:stat]
      attrs = {type: params[:stat],org_id: current_user.try(:organization_id)}
      @data = Ims::Order.order_search attrs
    end
    data = {
          org_id:current_user.try(:organization_id),#药房id
          flag:true, #true已收费  false 退费
          info:'您有新的已结算订单！cdsfsdef', #订单金额
        }
    ::NoticeBroadcastJob.perform_later(data:data)
    render json:@data.to_json
  end

  def get_order
    @data = Ims::Order.get_order({order_id:params[:id],org_id:current_user.try(:organization_id)})
    render json:@data.to_json
  end

  # 获取处方信息
  def get_prescriptions
    status = params[:stat]
    attrs = {status: status,org_id: current_user.try(:organization_id)}
    @data = Ims::Order.prescription_search attrs
    render json:@data.to_json
  end

  # # 获取处方信息
  def get_prescription
    attrs = {prescription_id:params[:id],org_id:current_user.try(:organization_id)}
    @data = Ims::Order.get_prescription(attrs)
    render json:@data.to_json
  end
  

  def get_detail
    id = params[:id]
    data = [{
      header:{id:"121sdf20sd1g2asd0f",status:"P",patient_name:"张三",},
      lines:[
        {item_code:"1090",text:"yaopin",total_quantity:"23",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
        {item_code:"1090",text:"yaopin",total_quantity:"23",unit:"克"},
      ]
      }]
    render json:data
  end

  # #POST 搜索平台处方 生成订单
  # def create_order
  #   p params[:id]
  #   p params[:method] #out_order  refuse_order   check_order   return_order
  #   # render json:{flag:false}
  #   new_order = [{id:"102101200",code:"1250201",name:"王晓伟",amount:"23.43"}]
  #   render json:new_order
  # end
  
  #订单收费
  def charging_pre
    p current_user
    drug_user = current_user.try(:name)
    drug_user_id = current_user.try(:id)
    temp = {id:params[:id],drug_user:drug_user,drug_user_id:drug_user_id,current_user:current_user,status:"2"}
    data = Orders::Order.order_completion(temp)
    re_data = data[:ret_code].to_i==0 ? {flag:true,info:'收费成功！'} : {flag:false,info:data[:info]}
    render json:re_data.to_json
  end

  # 订单发药
  def dispensing_order
    data = Ims::Order.dispensing_order params.merge(current_user:current_user)
    render json:data.to_json
  end

  
  # 获取已发送到该药店的订单
  # def get_orders
  # 	# p IPSocket.getaddress(Socket.gethostname)
  # 	@data = Ims::Order.order_search params.merge({org_ii:current_user.organization_id})
  #   render json:@data.to_json
  # end

  # 订单明细查询
  def get_order_detail
  	@data = Ims::Order.get_order_detail params.merge({org_ii:current_user.organization_id})
    render json:@data.to_json
  end

  # 未发订单或处方检索
  def get_search_data
    # @yd = Ims::Order.get_order_by_code params.merge({org_id:current_user.organization_id})
    attrs = {search:params[:search],org_id:current_user.organization_id}
    @data = Ims::Order.get_prescription_or_order_data attrs #unless @data[:flag]
    render json:@data.to_json
  end

  # 已发药或已退订单检索
  def get_order_by_code
    # params = {search:search}
    @data = Ims::Order.get_order_by_code params.merge({org_id:current_user.organization_id})
    render json:@data.to_json
  end

  # 平台处方收费或收费并发药操作
  # => 页面需传 prescription_ids(array) , status(string) ['2':收费,'5':收费并发药]
  def operat_order_by_prescription
    args= {org_id:current_user.organization_id,org_name:current_user.organization.name,user_id:current_user.id,user_name:current_user.name,current_user:current_user}
    @data = Ims::Order.operat_order_by_prescription params.merge(args)
    render json:@data.to_json
  end

  # 退药(目前只能线下退药)
  # => 页面需传 订单 id(string) 
  def return_drug
    args= {user_id:current_user.id,user_name:current_user.name,org_id:current_user.organization_id,current_user:current_user,reason:params[:reason]}
    @data = Ims::Order.return_drug params.merge(args)
    render json:@data.to_json
  end

  # 下载错误处方返回
  # => 页面需传 订单 id(string) 
  def prescription_back
    args= {user_id:current_user.id,user_name:current_user.name,org_id:current_user.organization_id}
    @data = Ims::Order.prescription_back params.merge(args)
    render json:@data.to_json
  end

  def order_setting
    p params
    render json:{flag:true, info:"设置成功！"}
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_order
      @ims_order = Ims::Order.find(params[:id]) rescue nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_order_params
      params.require(:ims_order).permit(:source_org_ii, :source_org_name, :target_org_ii, :target_org_name, :patient_order_id, :order_code, :patient_name, :repeat_number, :total_amount, :search_name, :note, :operater, :operat_at, :ori_id, :ori_code, :created_at, :updated_at)
    end
end
