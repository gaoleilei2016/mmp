#encoding:utf-8
#药品
class Hospital::OrdersController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/encounters
	def index
		@orders = Hospital::Order.all rescue []

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
      format.json { render json: {flag: true, info:"", data: @order} }
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
		@order = Hospital::Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'order was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @order} }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
	end

	# PUT
  # PUT /hospital/orders/:id
  def update

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'order was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @order} }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

	# DELETE
  # /hospital/orders/:id
	def destroy
		@order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Hospital::Order.find(params[:id])
    end
end
