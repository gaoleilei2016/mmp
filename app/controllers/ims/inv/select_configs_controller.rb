class Ims::Inv::SelectConfigsController < ApplicationController
  before_action :set_ims_inv_select_config, only: [:show, :edit, :update, :destroy]

  # GET /ims/inv/select_configs
  # GET /ims/inv/select_configs.json
  def index
    @ims_inv_select_configs = Ims::Inv::SelectConfig.all
  end

  # GET /ims/inv/select_configs/1
  # GET /ims/inv/select_configs/1.json
  def show
  end

  # GET /ims/inv/select_configs/new
  def new
    @ims_inv_select_config = Ims::Inv::SelectConfig.new
  end

  # GET /ims/inv/select_configs/1/edit
  def edit
  end

  # POST /ims/inv/select_configs
  # POST /ims/inv/select_configs.json
  def create
    @ims_inv_select_config = Ims::Inv::SelectConfig.new(ims_inv_select_config_params)

    respond_to do |format|
      if @ims_inv_select_config.save
        format.html { redirect_to @ims_inv_select_config, notice: 'Select config was successfully created.' }
        format.json { render :show, status: :created, location: @ims_inv_select_config }
      else
        format.html { render :new }
        format.json { render json: @ims_inv_select_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/inv/select_configs/1
  # PATCH/PUT /ims/inv/select_configs/1.json
  def update
    respond_to do |format|
      if @ims_inv_select_config.update(ims_inv_select_config_params)
        format.html { redirect_to @ims_inv_select_config, notice: 'Select config was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_inv_select_config }
      else
        format.html { render :edit }
        format.json { render json: @ims_inv_select_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/inv/select_configs/1
  # DELETE /ims/inv/select_configs/1.json
  def destroy
    @ims_inv_select_config.destroy
    respond_to do |format|
      format.html { redirect_to ims_inv_select_configs_url, notice: 'Select config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_select_config
      @ims_inv_select_config = Ims::Inv::SelectConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_select_config_params
      params.require(:ims_inv_select_config).permit(:use_org_id, :c_id, :use_name)
    end
end
