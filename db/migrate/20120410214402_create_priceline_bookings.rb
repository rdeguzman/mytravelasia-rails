class CreatePricelineBookings < ActiveRecord::Migration
  def self.up
    create_table :priceline_bookings do |t|
      t.integer :poi_id

      t.text :hotel_name

      t.text :address
      t.text :full_address

      t.integer :city_id
      t.string :city_name
      t.integer :country_id
      t.string :country_name

      t.string :min_rate
      t.string :currency_code

      t.integer :number_of_reviews, :default => 0
      t.integer :total_ratings, :default => 0

      t.string :hotel_web_url
      t.string :hotel_mobile_url

      t.decimal :longitude, :precision => 12, :scale => 6
      t.decimal :latitude, :precision => 12, :scale => 6

      t.text :hotel_description

      t.string :current_status, :default => 'new'

      t.timestamps
    end
  end

  def self.down
    drop_table :priceline_bookings
  end
end
