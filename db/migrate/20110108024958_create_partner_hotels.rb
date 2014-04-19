class CreatePartnerHotels < ActiveRecord::Migration
  def self.up
    create_table :partner_hotels do |t|
      t.references :poi
      t.string :hotel_file_name
      t.string :hotel_name
      t.integer :rating
      t.references :destination
      t.references :country
      t.string :address
      t.string :min_rate
      t.string :image_file_name
      t.string :currency_code
      t.decimal :longitude, :precision => 12, :scale => 8
      t.decimal :latitude, :precision => 12, :scale => 8
      t.integer :number_of_reviews
      t.integer :consumer_rating
      t.integer :property_type_id
      t.string :chain_id
      t.string :facility_list_id
      t.string :folder_name
      t.string :file_name
      t.string :check_in
      t.string :check_out
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_hotels
  end
end
