#encoding:utf-8
#接诊管理、统计
class Hospital::EncountersController < ApplicationController
	before_action :set_encounter, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/encounters
	def index
		@encounters = Hospital::Encounter.all rescue []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @encounters} }
    end
	end

	# GET
  # /hospital/encounters/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter} }
    end
	end

	# GET
  # GET /hospital/encounters/new.json
  def new
    @encounter = Hospital::Encounter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter} }
    end
  end

	# GET
  # /hospital/encounters/:id/edit
	def edit
	end

	# POST
  # /hospital/encounters
	def create
		@encounter = Hospital::Encounter.new(params[:encounter])

    respond_to do |format|
      if @encounter.save
        format.html { redirect_to @encounter, notice: 'encounter was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @encounter} }
      else
        format.html { render action: "new" }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
      end
    end
	end

	# PUT
  # PUT /hospital/encounters/:id
  def update

    respond_to do |format|
      if @encounter.update_attributes(params[:encounter])
        format.html { redirect_to @encounter, notice: 'encounter was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @encounter} }
      else
        format.html { render action: "edit" }
        format.json { render json: @encounter.errors, status: :unprocessable_entity }
      end
    end
  end

	# DELETE
  # /hospital/encounters/:id
	def destroy
		@encounter.destroy

    respond_to do |format|
      format.html { redirect_to encounters_url }
      format.json { head :no_content }
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_encounter
      @encounter = Hospital::Encounter.find(params[:id])
    end
end
