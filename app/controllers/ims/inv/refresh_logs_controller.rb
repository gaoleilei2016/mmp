class Ims::Inv::RefreshLogsController < ApplicationController
  before_action :set_ims_inv_refresh_log, only: [:show, :edit, :update, :destroy]

  # GET /ims/inv/refresh_logs
  # GET /ims/inv/refresh_logs.json
  def index
    p '12312312'
    @ims_inv_refresh_logs = Ims::Inv::RefreshLog.all
  end

  # GET /ims/inv/refresh_logs/1
  # GET /ims/inv/refresh_logs/1.json
  def show
  end

  # GET /ims/inv/refresh_logs/new
  def new
    @ims_inv_refresh_log = Ims::Inv::RefreshLog.new
  end

  # GET /ims/inv/refresh_logs/1/edit
  def edit
  end

  # POST /ims/inv/refresh_logs
  # POST /ims/inv/refresh_logs.json
  def create
    @ims_inv_refresh_log = Ims::Inv::RefreshLog.new(ims_inv_refresh_log_params)

    respond_to do |format|
      if @ims_inv_refresh_log.save
        format.html { redirect_to @ims_inv_refresh_log, notice: 'Refresh log was successfully created.' }
        format.json { render :show, status: :created, location: @ims_inv_refresh_log }
      else
        format.html { render :new }
        format.json { render json: @ims_inv_refresh_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/inv/refresh_logs/1
  # PATCH/PUT /ims/inv/refresh_logs/1.json
  def update
    respond_to do |format|
      if @ims_inv_refresh_log.update(ims_inv_refresh_log_params)
        format.html { redirect_to @ims_inv_refresh_log, notice: 'Refresh log was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_inv_refresh_log }
      else
        format.html { render :edit }
        format.json { render json: @ims_inv_refresh_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/inv/refresh_logs/1
  # DELETE /ims/inv/refresh_logs/1.json
  def destroy
    @ims_inv_refresh_log.destroy
    respond_to do |format|
      format.html { redirect_to ims_inv_refresh_logs_url, notice: 'Refresh log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_log
    puts "---#{params}--------------"
    logs = Ims::Inv::RefreshLog.get_log(params[:startDate].to_s, params[:endDate].to_s).order({created_at: 'desc'})
    dataSize = logs.size
    logs = logs.page(params[:page].to_i).per(params[:per].to_i)
    render json: { items: logs, dataLength: dataSize }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_refresh_log
      @ims_inv_refresh_log = Ims::Inv::RefreshLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_refresh_log_params
      params.require(:ims_inv_refresh_log).permit(:price,:medine,:peson, :person_code, :org_id, :medicine_id, :refresh_befor_num, :refresh_after_num, :update_PCIP,:status)
    end
end
