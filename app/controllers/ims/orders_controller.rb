class Ims::OrdersController < ApplicationController
  before_action :set_ims_order, only: [:show, :edit, :update, :destroy, :dispensing_order, :return_order, :oprate_order]

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
    when '3' #已发药
      type = ""
    when '4' #已退药
      type = ""
    else
      type = ""
    end
    org_id = ""#current_user.organization_id rescue ""
    order_code = ""#取药码  可以没有
    data  = []
    if params[:platform]
      data = [
        {id:"12435",code:"08020231",name:"rth",amount:"14.23"},
        {id:"46876",code:"08020233",name:"fghsr",amount:"16.23"},
        {id:"67874",code:"08020232",name:"ktys",amount:"52.23"},
      ]
    end

    #搜索药店的 订单 处方
    if params[:stat]
      @data = Orders::Order.get_order_to_medical({type:type,org_id:org_id})
      # @data.map{|line| data<<{
      #   id:line[:prescriptions_id],
      #   code:line[:order_code],
      #   name:line[:patient_name],
      #   amount:line[:amt],
      #   pres:line[:prescriptions_id].each_with_index do  { |e| {id:e, title:"处方1",amount:"52.23"} }
      #   }
      # }
    end
    render json:@data.to_json
  end

  def get_order
    data = [{id:"12435",code:"08020231",title:"汇总",amount:"14.23"},
        {id:"67874",code:"08020232",title:"处方1",amount:"52.23"},
        {id:"46876",code:"08020233",title:"处方2",amount:"16.23"},
        {id:"12435",code:"08020231",title:"处方3",amount:"14.23"},
        {id:"12435",code:"08020231",title:"处方4",amount:"14.23"}]
    render json:data.to_json
  end

  def get_detail
    p "++++++++++++++++++++++++++"
    p current_user.organization_id
    p "++++++++++++++++++++++++++"
    id = params[:id]
    data = [{
      header:{id:"121sdf20sd1g2asd0f",status:"P",patient_name:"张三",},
      lines:[
        {item_code:"1090",text:"yaopin",total_quantity:"23",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
        {item_code:"1002",text:"扇贝",total_quantity:"5",unit:"克"},
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
  
  # 订单发药
  def dispensing_order
    @reslut = @ims_order.dispensing_order rescue {flag:true,info:"发药成功！"}
    render json:@reslut.to_json
    # @reslut = @ims_order.dispensing_order
    # render json:@reslut.to_json
    # render json:{flag:true, info:"发药成功！"}
  end

  # 订单退药
  def return_order
    @reslut = @ims_order.return_order rescue {flag:true,info:"发药成功！"}
    render json:@reslut.to_json
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
