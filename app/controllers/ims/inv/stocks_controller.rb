#encoding:utf-8
# 库存
class Ims::Inv::StocksController < ApplicationController
	def index
	end

	# 库存导入
	def exports
		
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_stock
      @ims_order = Ims::Inv::Stock.find(params[:id]) rescue nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_stock_params
      params.require(:ims_inv_stock).permit(:org_id, :medicine_id, :pt_code, :code, :unit, :price, :mul, :batch, :location_id, :location_name, :quantity, :freeze_qty, :amount)
    end
end