class Ims::OrdersController < ApplicationController
  before_action :set_ims_order, only: [:show, :edit, :update, :destroy]
  # GET /ims/orders
  # GET /ims/orders.json
  def index
    @ims_orders = Ims::Order.all
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

  def get_orders
    #搜索平台的 订单 处方
    
    if params[:platform]
      data = [
        {id:"12435",code:"08020231",name:"rth",amount:"14.23"},
        {id:"46876",code:"08020233",name:"fghsr",amount:"16.23"},
        {id:"67874",code:"08020232",name:"ktys",amount:"52.23"},
      ]
    end

    #搜索药店的 订单 处方
    if params[:stat]
      data = [
        {id:"12435",code:"08020231",name:"rth",amount:"14.23"},
        {id:"67874",code:"08020232",name:"ktys",amount:"52.23"},
        {id:"46876",code:"08020233",name:"fghsr",amount:"16.23"},
        {id:"12435",code:"08020231",name:"rth",amount:"14.23"},
        {id:"12435",code:"08020231",name:"rth",amount:"14.23"},
        {id:"46876",code:"08020233",name:"fghsr",amount:"16.23"},
        {id:"67874",code:"08020232",name:"ktys",amount:"52.23"},        
      ]
    end
    render json:data.to_json
  end
  def get_order
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
    render json:data.to_json
  end

  def oprate_order
    p params[:id]
    p params[:method] #out_order  refuse_order   check_order   return_order
    # render json:{flag:false}
    render json:{flag:true}
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_order
      @ims_order = Ims::Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_order_params
      params.require(:ims_order).permit(:source_org_ii, :source_org_name, :target_org_ii, :target_org_name, :patient_order_id, :order_code, :patient_name, :repeat_number, :total_amount, :search_name, :note, :operater, :operat_at, :ori_id, :ori_code, :created_at, :updated_at)
    end
end
