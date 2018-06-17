#encoding:utf-8
#药品
class Hospital::OrdersController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/orders
	def index
    # 只能通过 encounter_id 查询医嘱
		# @orders = Hospital::Order.all rescue []
    @orders = Hospital::Order.where(encounter_id: params[:encounter_id]).map { |e| e.to_web_front  }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @orders} }
    end
	end

	# GET
  # /hospital/orders/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @order.to_web_front} }
    end
	end

	# GET
  # GET /hospital/orders/new.json
  def new
    @order = Hospital::Order.new
    res = {
      title: "",  # 药品名
    }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @order} }
    end
  end

	# GET
  # /hospital/orders/:id/edit
	def edit
	end

	# POST
  # /hospital/orders
	def create
    p "Hospital::OrdersController create",params
		@order = Hospital::Order.new(format_order_create_args)
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'order was successfully created.' }
        format.json { render json: {flag: true, info:"success", data: @order.to_web_front} }
      else
        format.html { render action: "new" }
        format.json { render json: {flag: false , info: @order.errors.messages.values.flatten} }
      end
    end
	end

	# PUT
  # PUT /hospital/orders/:id
  def update
    p "Hospital::OrdersController update",params
    respond_to do |format|
      if @order.update_attributes(format_order_update_args)
        format.html { redirect_to @order, notice: 'order was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @order.to_web_front} }
      else
        format.html { render action: "edit" }
        format.json { render json: {flag: false , info: @order.errors} }
      end
    end
  end

	# DELETE
  # /hospital/orders/:id
  #只提供json格式
  def destroy
    p "Hospital::OrdersController destroy",params
    respond_to do |format|
      if @order.status == 0 # 新建状态的可以删除
        if @order.destroy
          format.json { render json: {flag: true, info: "删除成功"}  }
        else
          format.json { render json: {flag: false, info: "删除失败 #{@order.errors.messages.values}"}  }
        end
      else
        format.json { render json: {flag: false, info: "删除失败 不是新建状态"}  }
      end
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Hospital::Order.find(params[:id])
    end

    def order_params
      params[:order]
    end

    def format_order_create_args
      args = order_params
      dict_mediaction_info = ::Dict::Medication.find(args[:serialno]).to_order_info()
      ret = {
        serialno: args[:serialno],
        title: args[:title],
        specification: args[:specification],
        formul_code: args[:formul][:code],
        formul_display: args[:formul][:display],
        single_qty_value: args[:single_qty][:value],
        single_qty_unit: args[:single_qty][:unit],
        dose_value: args[:dose][:value],
        dose_unit: args[:dose][:unit],
        route_code: args[:route][:code],
        route_display: args[:route][:display],
        frequency_code: args[:frequency][:code],
        frequency_display: args[:frequency][:display],
        course_of_treatment_value: args[:course_of_treatment][:value],
        course_of_treatment_unit: args[:course_of_treatment][:unit],
        total_quantity: args[:total_quantity],
        unit: args[:unit],
        price: args[:price],
        note: args[:note],
        status: 0,
        order_type: 1, # 默认保存1 是药品医嘱
        encounter_id: args[:encounter_id],
        author_id: current_user.id,
        type_type: args[:type]
      }
      ret.merge!(dict_mediaction_info)
      return ret
    end

    def format_order_update_args
      args = order_params
      dict_mediaction_info = ::Dict::Medication.find(args[:serialno]).to_order_info()
      ret = {
        serialno: args[:serialno],
        title: args[:title],
        specification: args[:specification],
        formul_code: args[:formul][:code],
        formul_display: args[:formul][:display],
        single_qty_value: args[:single_qty][:value],
        single_qty_unit: args[:single_qty][:unit],
        dose_value: args[:dose][:value],
        dose_unit: args[:dose][:unit],
        route_code: args[:route][:code],
        route_display: args[:route][:display],
        frequency_code: args[:frequency][:code],
        frequency_display: args[:frequency][:display],
        course_of_treatment_value: args[:course_of_treatment][:value],
        course_of_treatment_unit: args[:course_of_treatment][:unit],
        total_quantity: args[:total_quantity],
        unit: args[:unit],
        price: args[:price],
        note: args[:note],
        order_type: 1, # 默认保存1 是药品医嘱
        encounter_id: args[:encounter_id],
        author_id: current_user.id
      }
      ret.merge!(dict_mediaction_info)
      return ret
    end
end
