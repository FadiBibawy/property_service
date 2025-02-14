# == Schema Information
#
# Table name: properties
#
#  id                :integer          not null, primary key
#  offer_type        :string
#  property_type     :string
#  zip_code          :string
#  city              :string
#  street            :string
#  house_number      :string
#  lng               :decimal(11, 8)
#  lat               :decimal(11, 8)
#  construction_year :integer
#  number_of_rooms   :decimal(, )
#  price             :decimal(, )
#  currency          :string
#  created_at        :datetime
#  updated_at        :datetime
#

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

    find_by_sql([ query, lat, lng, property_type, marketing_type, lat, lng, radius ])
  end
end
