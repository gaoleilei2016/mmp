class Ims::Inv::StocksController < ApplicationController
  before_action :set_ims_inv_stock, only: [:show, :edit, :update, :destroy]

  # GET /ims/inv/stocks
  # GET /ims/inv/stocks.json
  def index
    @ims_inv_stocks = Ims::Inv::Stock.all
  end

  # GET /ims/inv/stocks/1
  # GET /ims/inv/stocks/1.json
  def show
  end

  # GET /ims/inv/stocks/new
  def new
    @ims_inv_stock = Ims::Inv::Stock.new
  end

  # GET /ims/inv/stocks/1/edit
  def edit
  end

  # POST /ims/inv/stocks
  # POST /ims/inv/stocks.json
  def create
    @ims_inv_stock = Ims::Inv::Stock.new(ims_inv_stock_params)

    respond_to do |format|
      if @ims_inv_stock.save
        format.html { redirect_to @ims_inv_stock, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @ims_inv_stock }
      else
        format.html { render :new }
        format.json { render json: @ims_inv_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/inv/stocks/1
  # PATCH/PUT /ims/inv/stocks/1.json
  def update
    respond_to do |format|
      if @ims_inv_stock.update(ims_inv_stock_params)
        format.html { redirect_to @ims_inv_stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_inv_stock }
      else
        format.html { render :edit }
        format.json { render json: @ims_inv_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/inv/stocks/1
  # DELETE /ims/inv/stocks/1.json
  def destroy
    @ims_inv_stock.destroy
    respond_to do |format|
      format.html { redirect_to ims_inv_stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # 库存导入
  def exports
    
  end

  def get_file
    result = {flag:true,info:"保存成功。"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_stock
      @ims_inv_stock = Ims::Inv::Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_stock_params
      params.require(:ims_inv_stock).permit(:org_id, :medicine_id, :pt_code, :code, :unit, :price, :mul, :batch, :location_id, :location_name, :quantity, :freeze_qty, :amount, :created_at, :updated_at)
    end
end
