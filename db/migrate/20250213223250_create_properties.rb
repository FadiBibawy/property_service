class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :offer_type
      t.string :property_type
      t.string :zip_code
      t.string :city
      t.string :street
      t.string :house_number
      t.decimal :lng, precision: 11, scale: 8
      t.decimal :lat, precision: 11, scale: 8
      t.integer :construction_year
      t.decimal :number_of_rooms
      t.decimal :price
      t.string :currency

      t.timestamps
    end
  end
end
