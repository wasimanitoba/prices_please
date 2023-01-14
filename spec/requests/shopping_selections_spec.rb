require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/shopping_selections", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # ShoppingSelection. As you add validations to ShoppingSelection, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ShoppingSelection.create! valid_attributes
      get shopping_selections_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      shopping_selection = ShoppingSelection.create! valid_attributes
      get shopping_selection_url(shopping_selection)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_shopping_selection_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      shopping_selection = ShoppingSelection.create! valid_attributes
      get edit_shopping_selection_url(shopping_selection)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ShoppingSelection" do
        expect {
          post shopping_selections_url, params: { shopping_selection: valid_attributes }
        }.to change(ShoppingSelection, :count).by(1)
      end

      it "redirects to the created shopping_selection" do
        post shopping_selections_url, params: { shopping_selection: valid_attributes }
        expect(response).to redirect_to(shopping_selection_url(ShoppingSelection.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ShoppingSelection" do
        expect {
          post shopping_selections_url, params: { shopping_selection: invalid_attributes }
        }.to change(ShoppingSelection, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post shopping_selections_url, params: { shopping_selection: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested shopping_selection" do
        shopping_selection = ShoppingSelection.create! valid_attributes
        patch shopping_selection_url(shopping_selection), params: { shopping_selection: new_attributes }
        shopping_selection.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the shopping_selection" do
        shopping_selection = ShoppingSelection.create! valid_attributes
        patch shopping_selection_url(shopping_selection), params: { shopping_selection: new_attributes }
        shopping_selection.reload
        expect(response).to redirect_to(shopping_selection_url(shopping_selection))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        shopping_selection = ShoppingSelection.create! valid_attributes
        patch shopping_selection_url(shopping_selection), params: { shopping_selection: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested shopping_selection" do
      shopping_selection = ShoppingSelection.create! valid_attributes
      expect {
        delete shopping_selection_url(shopping_selection)
      }.to change(ShoppingSelection, :count).by(-1)
    end

    it "redirects to the shopping_selections list" do
      shopping_selection = ShoppingSelection.create! valid_attributes
      delete shopping_selection_url(shopping_selection)
      expect(response).to redirect_to(shopping_selections_url)
    end
  end
end
