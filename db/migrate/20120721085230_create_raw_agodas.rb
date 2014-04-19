class CreateRawAgodas < ActiveRecord::Migration
  def self.up
    create_table :raw_agodas do |t|
      t.integer :id
      t.integer :chain_id
      t.string  :chain_name
      t.integer  :brand_id
      t.string  :brand_name
      t.string  :hotel_name
      t.string  :hotel_formerly_name
      t.string  :hotel_translated_name
      t.string  :addressline1
      t.string  :addressline2
      t.string  :zipcode
      t.string  :city
      t.string  :state
      t.string  :country
      t.string  :countryisocode
      t.string  :star_rating
      t.decimal :longitude, :precision => 12, :scale => 6
      t.decimal :latitude, :precision => 12, :scale => 6
      t.string  :url
      t.string  :checkin
      t.string  :checkout
      t.string  :numberrooms
      t.string  :numberfloors
      t.string  :yearopened
      t.string  :yearrenovated
      t.string  :photo1
      t.string  :photo2
      t.string  :photo3
      t.string  :photo4
      t.string  :photo5
      t.text  :overview
      t.integer  :rates_from_usd
      t.integer  :continent_id
      t.string  :continent_name
      t.integer  :city_id
      t.integer :country_id
      t.integer  :number_of_reviews
      t.float  :rating_average

      t.timestamps
    end
  end

  def self.down
    drop_table :raw_agodas
  end
end
