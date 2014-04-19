class CreatePois < ActiveRecord::Migration
  def self.up
    create_table :pois do |t|
      t.string :name
      t.string :address
      
      t.string :tel_no
      t.string :web_url
      t.string :email
      
      t.decimal :longitude, :precision => 12, :scale => 6
      t.decimal :latitude, :precision => 12, :scale => 6
      
      t.references :destination
      t.string  :destination_name
      
      t.references :country
      t.string  :country_name
      
      t.text :description
      
      t.references :poi_type
      t.string :poi_type_name
      
      t.float :total_stars, :default => 0
      t.integer :total_ratings, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pois
  end
end
