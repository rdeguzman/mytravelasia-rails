class CreateHotelsCombineds < ActiveRecord::Migration
  def self.up
    create_table :hotels_combineds do |t|
      t.text :hotel_file_name
      t.text :hotel_name

      t.integer :rating

      t.integer :city_id
      t.string :city_file_name
      t.string :city_name

      t.integer :state_id
      t.string :state_file_name
      t.string :state_name

      t.integer :country_code
      t.string :country_file_name
      t.string :country_name

      t.text :image_id

      t.text :address

      t.string :min_rate
      t.string :currency_code

      t.decimal :latitude, :precision => 12, :scale => 6
      t.decimal :longitude, :precision => 12, :scale => 6
      t.integer :number_of_reviews
      t.integer :consumer_rating
      t.integer :property_type
      t.string :chain_id
      t.string :facilities
      t.text :hotel_description
      t.text :hotel_description_raw
      t.text :images
      t.text :hotel_web_url
      t.text :hotel_mobile_url
      t.string :rate_from #should be in USD

      t.string :folder
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :hotels_combineds
  end
end
