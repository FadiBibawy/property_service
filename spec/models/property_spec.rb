require 'rails_helper'

RSpec.describe Property, type: :model do
  describe ".within_radius" do
    let(:latitude)       { 52.5342963 }
    let(:longitude)      { 13.4236807 }
    let(:radius)         { 5000 }
    let(:property_type)  { "apartment" }
    let(:marketing_type) { "sell" }

    before do
      # Create a property that is near the given coordinates.
      @near_property = Property.create!(
        offer_type:      marketing_type,
        property_type:   property_type,
        zip_code:        "10115",
        city:            "Berlin",
        street:          "Nearby Street",
        house_number:    "10",
        lng:             longitude + 0.002,  # small offset (within 5 km)
        lat:             latitude + 0.002,   # small offset (within 5 km)
        construction_year: 1900,
        number_of_rooms: 3,
        currency:        "eur",
        price:           300_000
      )

      # Create a property that is far from the given coordinates.
      @far_property = Property.create!(
        offer_type:      marketing_type,
        property_type:   property_type,
        zip_code:        "10115",
        city:            "Berlin",
        street:          "Far Street",
        house_number:    "20",
        lng:             longitude + 0.1,  # larger offset (outside 5 km)
        lat:             latitude + 0.1,   # larger offset (outside 5 km)
        construction_year: 1900,
        number_of_rooms: 3,
        currency:        "eur",
        price:           400_000
      )
    end

    it "returns only properties within the specified radius" do
      results = Property.within_radius(latitude, longitude, radius, property_type, marketing_type)
      expect(results).to include(@near_property)
      expect(results).not_to include(@far_property)
    end
  end
end
