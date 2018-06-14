#encoding:utf-8
#历史记录
class Hospital::HistoriesController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/histories
	def index
    @encounters = Hospital::Encounter.all.map { |e| e.to_web_front  }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @encounters} }
    end
	end

	# GET
  # /hospital/histories/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @order} }
    end
	end

	# GET
  # GET /hospital/histories/new.json
  def new
    @order = Hospital::Encounter.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @order} }
    end
  end

	# GET
  # /hospital/histories/:id/edit
	def edit
	end

	# POST
  # /hospital/histories
	def create
		@order = Hospital::Encounter.new(params[:order])

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
  # PUT /hospital/histories/:id
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
  # /hospital/histories/:id
	def destroy
		@order.destroy

    respond_to do |format|
      format.html { redirect_to histories_url }
      format.json { head :no_content }
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Hospital::Encounter.find(params[:id])
    end
end
