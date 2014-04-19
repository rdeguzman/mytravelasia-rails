class CreateAgodas < ActiveRecord::Migration
  def self.up
    create_table :agodas do |t|
      t.text :hotel_name

      t.text :address_i
      t.text :address_ii

      t.integer :country_id
      t.string :country_name

      t.integer :city_id
      t.string :city_name

      t.integer :area_id
      t.string :area_name

      t.text :hotel_description
      t.integer :star_rating

      t.text :hotel_url

      t.integer :number_of_reviews
      t.float :user_rating_average
      t.string :rate_from

      t.decimal :longitude, :precision => 12, :scale => 6
      t.decimal :latitude, :precision => 12, :scale => 6

      t.string :phone_number
      t.string :fax_number

      t.timestamps
    end
  end

  def self.down
    drop_table :agodas
  end
end
