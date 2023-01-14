class ShoppingSelectionsController < ApplicationController
  before_action :set_shopping_selection, only: %i[ show edit update destroy ]

  # GET /shopping_selections or /shopping_selections.json
  def index
    @shopping_selections = ShoppingSelection.all
  end

  # GET /shopping_selections/1 or /shopping_selections/1.json
  def show
  end

  # GET /shopping_selections/new
  def new
    @shopping_selection = ShoppingSelection.new
  end

  # GET /shopping_selections/1/edit
  def edit
  end

  # POST /shopping_selections or /shopping_selections.json
  def create
    @shopping_selection = ShoppingSelection.new(shopping_selection_params)

    respond_to do |format|
      if @shopping_selection.save
        format.html { redirect_to shopping_selection_url(@shopping_selection), notice: "Shopping selection was successfully created." }
        format.json { render :show, status: :created, location: @shopping_selection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shopping_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_selections/1 or /shopping_selections/1.json
  def update
    respond_to do |format|
      if @shopping_selection.update(shopping_selection_params)
        format.html { redirect_to shopping_selection_url(@shopping_selection), notice: "Shopping selection was successfully updated." }
        format.json { render :show, status: :ok, location: @shopping_selection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shopping_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_selections/1 or /shopping_selections/1.json
  def destroy
    @shopping_selection.destroy

    respond_to do |format|
      format.html { redirect_to shopping_selections_url, notice: "Shopping selection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_selection
      @shopping_selection = ShoppingSelection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shopping_selection_params
      params.require(:shopping_selection).permit(:recommend_store_id, :alternate_store_id, :best_deal_id, :alternate_product_id, :alternate_brand_id)
    end
end
