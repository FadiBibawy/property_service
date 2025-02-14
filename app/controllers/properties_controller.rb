class PropertiesController < ApplicationController
  def index
    # Validate required parameters
    required_params = %w[lat lng property_type marketing_type]
    missing = required_params.select { |p| params[p].blank? }
    if missing.any?
      return render json: { error: "Missing required parameters: #{missing.join(', ')}" }, status: :bad_request
    end

    # Validate that latitude and longitude are numeric
    begin
      lat = Float(params[:lat])
      lng = Float(params[:lng])
    rescue ArgumentError
      return render json: { error: "Latitude and longitude must be valid numbers" }, status: :bad_request
    end

    # Validate Allowed values for property_type & marketing_type
    allowed_property_types = ["apartment", "single_family_house"]
    allowed_marketing_types = ["rent", "sell"]

    property_type = params[:property_type]
    marketing_type = params[:marketing_type]

    unless allowed_property_types.include?(property_type)
      return render json: { error: "Invalid property_type. Allowed values are: #{allowed_property_types.join(', ')}" }, status: :bad_request
    end

    unless allowed_marketing_types.include?(marketing_type)
      return render json: { error: "Invalid marketing_type. Allowed values are: #{allowed_marketing_types.join(', ')}" }, status: :bad_request
    end

    radius = 5000

    properties = Property.within_radius(lat, lng, radius, property_type, marketing_type)

    if properties.empty?
      return render json: { error: "No properties found for the given location and filters" }, status: :not_found
    end

    results = properties.map do |prop|
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

    render json: results, status: :ok
  end

  # Rescue from unforeseen errors and return JSON response
  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end
end
