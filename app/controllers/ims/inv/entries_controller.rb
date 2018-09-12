class Ims::Inv::EntriesController < ApplicationController
  before_action :set_ims_inv_entry, only: [:show, :edit, :update, :destroy]

  # GET /ims/inv/entries
  # GET /ims/inv/entries.json
  def index
    @ims_inv_entries = Ims::Inv::Entry.all
  end

  # GET /ims/inv/entries/1
  # GET /ims/inv/entries/1.json
  def show
  end

  # GET /ims/inv/entries/new
  def new
    @ims_inv_entry = Ims::Inv::Entry.new
  end

  # GET /ims/inv/entries/1/edit
  def edit
  end

  # POST /ims/inv/entries
  # POST /ims/inv/entries.json
  def create
    @ims_inv_entry = Ims::Inv::Entry.new(ims_inv_entry_params)

    respond_to do |format|
      if @ims_inv_entry.save
        format.html { redirect_to @ims_inv_entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @ims_inv_entry }
      else
        format.html { render :new }
        format.json { render json: @ims_inv_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ims/inv/entries/1
  # PATCH/PUT /ims/inv/entries/1.json
  def update
    respond_to do |format|
      if @ims_inv_entry.update(ims_inv_entry_params)
        format.html { redirect_to @ims_inv_entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @ims_inv_entry }
      else
        format.html { render :edit }
        format.json { render json: @ims_inv_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ims/inv/entries/1
  # DELETE /ims/inv/entries/1.json
  def destroy
    @ims_inv_entry.destroy
    respond_to do |format|
      format.html { redirect_to ims_inv_entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ims_inv_entry
      @ims_inv_entry = Ims::Inv::Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ims_inv_entry_params
      params.require(:ims_inv_entry).permit(:org_id, :medicine_id, :name, :spec, :formul_name, :entry_type, :pt_code, :code, :unit, :price, :mul, :batch, :location_id, :location_name, :quantity, :amount, :source_id, :source_name, :document_id, :document_code, :document_line_id, :note, :operater, :operater_id, :operat_at, :patient_name, :posting_on, :created_at, :updated_at)
    end
end
