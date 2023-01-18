class AdminController < ApplicationController

  def pipeline
    @scrape = true
  end

  def scrape
    @raw_ingested_data = true
    respond_to do |format|
      format.html { render('admin/pipeline') }
    end
  end

  def transform
    @transformed_data = true

    respond_to do |format|
      format.html { render('admin/pipeline') }
    end
  end

  def load
    @loaded = true

    respond_to do |format|
      format.html { render('admin/pipeline') }
    end
  end
end
