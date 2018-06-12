class Ims::OrdersController < ApplicationController
  before_action :set_ims_order, only: [:show, :edit, :update, :destroy, :dispensing_order, :return_order]

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

  # 订单发药
  def dispensing_order
    @reslut = @ims_order.dispensing_order
    render json:@reslut.to_json
  end

  # 订单退药
  def return_order
    @reslut = @ims_order.return_order
    render json:@reslut.to_json
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
