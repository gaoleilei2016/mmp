class Ims::Inv::UseConfigsController < ApplicationController
  before_action :set_ims_inv_use_config, only: [:show, :edit, :update, :destroy]

  # GET /ims/inv/use_configs
  # GET /ims/inv/use_configs.json
  def index
    @ims_inv_use_configs = Ims::Inv::UseConfig.all
  end

  # GET /ims/inv/use_configs/1
  # GET /ims/inv/use_configs/1.json
  def show
  end

  # GET /ims/inv/use_configs/new
  def new
    @ims_inv_use_config = Ims::Inv::UseConfig.new
  end

  # GET /ims/inv/use_configs/1/edit
  def edit
  end

  # POST /ims/inv/use_configs
  # POST /ims/inv/use_configs.json
  def create
    @ims_inv_use_config = Ims::Inv::UseConfig.new(ims_inv_use_config_params)

    respond_to do |format|
      if @ims_inv_use_config.save
        format.html { redirect_to @ims_inv_use_config, notice: 'Use config was successfully created.' }
        format.json { render :show, status: :created, location: @ims_inv_use_config }
      else
        format.html { render :new }
        format.json { render json: @ims_inv_use_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/inv/use_configs/1
  # PATCH/PUT /ims/inv/use_configs/1.json
  def update
    respond_to do |format|
      if @ims_inv_use_config.update(ims_inv_use_config_params)
        format.html { redirect_to @ims_inv_use_config, notice: 'Use config was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_inv_use_config }
      else
        format.html { render :edit }
        format.json { render json: @ims_inv_use_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/inv/use_configs/1
  # DELETE /ims/inv/use_configs/1.json
  def destroy
    @ims_inv_use_config.destroy
    respond_to do |format|
      format.html { redirect_to ims_inv_use_configs_url, notice: 'Use config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_use_config
      @ims_inv_use_config = Ims::Inv::UseConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_use_config_params
      params.require(:ims_inv_use_config).permit(:use_system, :config)
    end
end
