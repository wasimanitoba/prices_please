# frozen_string_literal: true

class ErrandsController < ApplicationController
  before_action :set_errand, only: %i[show edit update destroy]

  # GET /errands or /errands.json
  def index
    @errands = Errand.all
  end

  # GET /errands/1 or /errands/1.json
  def show; end

  # GET /errands/new
  def new
    @errand = Errand.new
  end

  # GET /errands/1/edit
  def edit; end

  # POST /errands or /errands.json
  def create
    @errand = Errand.new(errand_params)

    respond_to do |format|
      if @errand.save
        format.html { redirect_to errand_url(@errand), notice: 'Errand was successfully created.' }
        format.json { render :show, status: :created, location: @errand }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @errand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /errands/1 or /errands/1.json
  def update
    respond_to do |format|
      if @errand.update(errand_params)
        format.html { redirect_to errand_url(@errand), notice: 'Errand was successfully updated.' }
        format.json { render :show, status: :ok, location: @errand }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @errand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /errands/1 or /errands/1.json
  def destroy
    @errand.destroy

    respond_to do |format|
      format.html { redirect_to errands_url, notice: 'Errand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_errand
    @errand = Errand.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def errand_params
    params.require(:errand).permit(:quantity, :maximum_spend, :brand_id, :estimated_serving_count, :estimated_serving_measurement)
  end
end
