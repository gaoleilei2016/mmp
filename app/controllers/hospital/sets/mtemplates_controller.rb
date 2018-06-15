#encoding:utf-8
#医嘱模板
class Hospital::Sets::MtemplatesController < ApplicationController
  before_action :set_mtemplate, only: [:show, :edit, :update, :destroy]
  # GET
  # /hospital/sets/mtemplates
  def index
    @mtemplates = Hospital::Sets::Mtemplate.all.map { |e| e.to_web_front  }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @mtemplates} }
    end
  end

  # GET
  # /hospital/sets/mtemplates/:id
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @mtemplate} }
    end
  end

  # GET
  # GET /hospital/sets/mtemplates/new.json
  def new
    @mtemplate = Hospital::Sets::Mtemplate.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @mtemplate} }
    end
  end

  # GET
  # /hospital/sets/mtemplates/:id/edit
  def edit
  end

  # POST
  # /hospital/sets/mtemplates
  def create
    @mtemplate = Hospital::Sets::Mtemplate.new(params[:mtemplate])

    respond_to do |format|
      if @mtemplate.save
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate} }
      else
        format.html { render action: "new" }
        format.json { render json: @mtemplate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT
  # PUT /hospital/sets/mtemplates/:id
  def update

    respond_to do |format|
      if @mtemplate.update_attributes(params[:mtemplate])
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate} }
      else
        format.html { render action: "edit" }
        format.json { render json: @mtemplate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE
  # /hospital/sets/mtemplates/:id
  def destroy
    @mtemplate.destroy

    respond_to do |format|
      format.html { redirect_to histories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mtemplate
      @mtemplate = Hospital::Sets::Mtemplate.find(params[:id])
    end
end
