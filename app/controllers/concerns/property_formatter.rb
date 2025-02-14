module PropertyFormatter
  extend ActiveSupport::Concern

  def format_properties(properties)
    properties.map do |prop|
      {
        house_number: prop.house_number,
        street:       prop.street,
        city:         prop.city,
        zip_code:     prop.zip_code,
        state:        prop.city,
        lat:          prop.lat.to_s,
        lng:          prop.lng.to_s,
        price:        prop.price.to_s
      }
    end
  end
end
