class Ims::SettingsController < ApplicationController
  # before_action :set_ims_setting, only: [:show, :edit, :update, :destroy]

  # GET /ims/settings
  # GET /ims/settings.json
  def index
    @ims_settings = Ims::Setting.all
  end

  # GET /ims/settings/1
  # GET /ims/settings/1.json
  def show
  end

  # GET /ims/settings/new
  def new
    @ims_setting = Ims::Setting.new
  end

  # GET /ims/settings/1/edit
  def edit
  end

  # POST /ims/settings
  # POST /ims/settings.json
  def create
    p "create"
    p ims_setting_params
    @ims_setting = Ims::Setting.new(ims_setting_params)

    respond_to do |format|
      if @ims_setting.save
        format.html { redirect_to @ims_setting, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @ims_setting }
      else
        format.html { render :new }
        format.json { render json: @ims_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/settings/1
  # PATCH/PUT /ims/settings/1.json
  def update
    p "update"
    respond_to do |format|
      if @ims_setting.update(ims_setting_params)
        format.html { redirect_to @ims_setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_setting }
      else
        format.html { render :edit }
        format.json { render json: @ims_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/settings/1
  # DELETE /ims/settings/1.json
  def destroy
    @ims_setting.destroy
    respond_to do |format|
      format.html { redirect_to ims_settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_cur_set
    data = {id:"54sd5g5a8d2ga5sd5gfa5",validity:23, voice:"yes"}
    render json:{flag:true,info:"success",data:data}
  end

  def save_settings
    p params
    render json:{flag:true,info:"success"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_setting
      @ims_setting = Ims::Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_setting_params
      params.require(:ims_setting).permit(:ii_root, :returned_at, :payment_Expired, :unpaid_expired)
    end
end
