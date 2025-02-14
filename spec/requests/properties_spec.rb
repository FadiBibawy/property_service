require 'rails_helper'

RSpec.describe 'Properties API', type: :request do
  describe 'GET /properties' do
    let(:valid_params) do
      {
        lat: '52.5342963',
        lng: '13.4236807',
        property_type: 'apartment',
        marketing_type: 'sell'
      }
    end

    it 'returns error if required params are missing' do
      get "/properties"

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to include("Missing required parameters")
    end

    it "returns error if lat/lng are not numbers" do
      get "/properties", params: valid_params.merge(lat: "abc", lng: "def")

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to include("Latitude and longitude must be valid numbers")
    end

    it "returns error for invalid property_type" do
      get "/properties", params: valid_params.merge(property_type: "invalid")

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to include("Invalid property_type")
    end

    it "returns error for invalid marketing_type" do
      get "/properties", params: valid_params.merge(marketing_type: "invalid")

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to include("Invalid marketing_type")
    end

    it "returns properties for valid params" do
      Property.create!(
        offer_type: "sell",
        property_type: "apartment",
        zip_code: "10405",
        city: "Berlin",
        street: "Test Street",
        house_number: "1",
        lng: 13.4236807,
        lat: 52.5342963,
        price: 350000,
        currency: "eur"
      )

      get "/properties", params: valid_params

      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result).not_to be_empty
    end
  end
end
