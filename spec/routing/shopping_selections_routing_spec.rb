require "rails_helper"

RSpec.describe ShoppingSelectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/shopping_selections").to route_to("shopping_selections#index")
    end

    it "routes to #new" do
      expect(get: "/shopping_selections/new").to route_to("shopping_selections#new")
    end

    it "routes to #show" do
      expect(get: "/shopping_selections/1").to route_to("shopping_selections#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/shopping_selections/1/edit").to route_to("shopping_selections#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/shopping_selections").to route_to("shopping_selections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/shopping_selections/1").to route_to("shopping_selections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/shopping_selections/1").to route_to("shopping_selections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/shopping_selections/1").to route_to("shopping_selections#destroy", id: "1")
    end
  end
end
