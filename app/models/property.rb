class Property < ApplicationRecord
  def self.within_radius(lat, lng, radius, property_type, marketing_type)
    query = <<-SQL.squish
      SELECT *,
      earth_distance(ll_to_earth(?, ?), ll_to_earth(lat::double precision, lng::double precision)) AS distance
      FROM properties
      WHERE property_type = ?
        AND offer_type = ?
        AND earth_distance(ll_to_earth(?, ?), ll_to_earth(lat::double precision, lng::double precision)) <= ?
      ORDER BY distance ASC
    SQL

    find_by_sql([query, lat, lng, property_type, marketing_type, lat, lng, radius])
  end
end
